#ifndef FFT_CLASS_HH
#include <vector>
#include "Matlib.h"

// sglee namespace fft_utils {
namespace fft_utils_fxp {


    struct traits
    {
        typedef _REAL scalar_type;
        typedef complex<scalar_type> complex_type;
        typedef complex<FXP> fcomplex_type; // sglee
        // sglee void fill_twiddles( complex_type * dst ,int nfft,bool inverse)
        void fill_twiddles( fcomplex_type * dst ,int nfft,bool inverse)
        {
            for (int i = 0; i < nfft; ++i) {
                _REAL phase =
                    -2*3.14159265358979323846264338327 * ((_REAL) (i) / (nfft) );
                if (inverse)
                    phase *= -1;
                // sglee dst[i]=complex_type(cos(phase),sin(phase));
		//printf ("flp twiddle : %f, %f \n", cos(phase), sin(phase));
                dst[i]=fcomplex_type(FXP(cos(phase)),FXP(sin(phase)));
		//printf ("fxp twiddle : %f, %f \n", (double)(dst[i].real()), (double)(dst[i].imag()));
            }
        }

        void prepare(
                // sglee std::vector< complex_type > & dst,
                std::vector< fcomplex_type > & dst,
                int nfft,bool inverse, 
                std::vector<int> & stageRadix, 
                std::vector<int> & stageRemainder )
        {
            _twiddles.resize(nfft);
            fill_twiddles( &_twiddles[0],nfft,inverse);
            dst = _twiddles;

            int n= nfft;
            int p=4;
            do {
                while (n % p) {
                    switch (p) {
                        case 4: p = 2; break;
                        case 2: p = 3; break;
                        default: p += 2; break;
                    }
                    if (p*p>n)
                        p=n;// no more factors
                }
                n /= p;
                stageRadix.push_back(p);
                stageRemainder.push_back(n);
            }while(n>1);
        }
        // sglee std::vector<complex_type> _twiddles;
        std::vector<fcomplex_type> _twiddles;


        // sglee const complex_type twiddle(int i) { return _twiddles[i]; }
        const fcomplex_type twiddle(int i) { return _twiddles[i]; }
    };

}

// sglee class fft
class fft_fxp
{
    public:
        // sglee typedef fft_utils::traits traits_type;
        typedef fft_utils_fxp::traits traits_type;
        typedef traits_type::scalar_type scalar_type;
        typedef traits_type::complex_type complex_type;
        typedef traits_type::fcomplex_type fcomplex_type; // sglee

        // sglee fft(int nfft,bool inverse,const traits_type & traits=traits_type() ) 
        fft_fxp(int nfft,bool inverse,const traits_type & traits=traits_type() ) 
            :_nfft(nfft),_inverse(inverse),_traits(traits)
        {
            _traits.prepare(_twiddles, _nfft,_inverse ,_stageRadix, _stageRemainder);
        }

        // sglee void transform(const complex_type * src , complex_type * dst)
        void transform(const fcomplex_type * src , fcomplex_type * dst)
        {
	    // printf ("sglee fft_fxp\n");

            work(0, dst, src, 1,1);
        }

    private:
        // sglee void work( int stage,complex_type * Fout, const complex_type * f, size_t fstride,size_t in_stride)
        void work( int stage,fcomplex_type * Fout, const fcomplex_type * f, size_t fstride,size_t in_stride)
        {
            int p = _stageRadix[stage];
            int m = _stageRemainder[stage];
            // sglee complex_type * Fout_beg = Fout;
            // sglee complex_type * Fout_end = Fout + p*m;
            fcomplex_type * Fout_beg = Fout;
            fcomplex_type * Fout_end = Fout + p*m;

            if (m==1) {
                do{
                    *Fout = *f;
                    f += fstride*in_stride;
                }while(++Fout != Fout_end );
            }else{
                do{
                    // recursive call:
                    // DFT of size m*p performed by doing
                    // p instances of smaller DFTs of size m, 
                    // each one takes a decimated version of the input
                    work(stage+1, Fout , f, fstride*p,in_stride);
                    f += fstride*in_stride;
                }while( (Fout += m) != Fout_end );
            }

            Fout=Fout_beg;

            // recombine the p smaller DFTs 
            switch (p) {
                case 2: bfly2(Fout,fstride,m); break;
                case 3: bfly3(Fout,fstride,m); break;
                case 4: bfly4(Fout,fstride,m); break;
                case 5: bfly5(Fout,fstride,m); break;
                default: bfly_generic(Fout,fstride,m,p); break;
            }
        }

        // these were #define macros in the original fft

        // sglee void bfly2( complex_type * Fout, const size_t fstride, int m)
        void bfly2( fcomplex_type * Fout, const size_t fstride, int m)
        {
            for (int k=0;k<m;++k) {
                // sglee complex_type t = Fout[m+k] * _traits.twiddle(k*fstride);
                fcomplex_type t = Fout[m+k] * _traits.twiddle(k*fstride);
                Fout[m+k] = Fout[k] - t;
                Fout[k] += t;
            }
        }

        // sglee void bfly4( complex_type * Fout, const size_t fstride, const size_t m)
        void bfly4( fcomplex_type * Fout, const size_t fstride, const size_t m)
        {
            // sglee complex_type scratch[7];
            fcomplex_type scratch[7];
            int negative_if_inverse = _inverse * -2 +1;
            for (size_t k=0;k<m;++k) {
                scratch[0] = Fout[k+m] * _traits.twiddle(k*fstride);
                scratch[1] = Fout[k+2*m] * _traits.twiddle(k*fstride*2);
                scratch[2] = Fout[k+3*m] * _traits.twiddle(k*fstride*3);
                scratch[5] = Fout[k] - scratch[1];

                Fout[k] += scratch[1];
                scratch[3] = scratch[0] + scratch[2];
                scratch[4] = scratch[0] - scratch[2];
                // sglee scratch[4] = complex_type( scratch[4].imag()*negative_if_inverse , -scratch[4].real()* negative_if_inverse );
                scratch[4] = fcomplex_type( scratch[4].imag()*negative_if_inverse , -scratch[4].real()* negative_if_inverse );

                Fout[k+2*m]  = Fout[k] - scratch[3];
                Fout[k] += scratch[3];
                Fout[k+m] = scratch[5] + scratch[4];
                Fout[k+3*m] = scratch[5] - scratch[4];
            }
        }

        // sglee void bfly3( complex_type * Fout, const size_t fstride, const size_t m)
        void bfly3( fcomplex_type * Fout, const size_t fstride, const size_t m)
        {
            size_t k=m;
            const size_t m2 = 2*m;
            // sglee complex_type *tw1,*tw2;
            // sglee complex_type scratch[5];
            // sglee complex_type epi3;
            fcomplex_type *tw1,*tw2;
            fcomplex_type scratch[5];
            fcomplex_type epi3;
            epi3 = _twiddles[fstride*m];

            tw1=tw2=&_twiddles[0];

            do{

                scratch[1]=Fout[m] * *tw1;
                scratch[2]=Fout[m2] * *tw2;

                scratch[3]=scratch[1]+scratch[2];
                scratch[0]=scratch[1]-scratch[2];
                tw1 += fstride;
                tw2 += fstride*2;

                // sglee Fout[m] = complex_type( Fout->real() - (scratch[3].real()*0.5 ) , Fout->imag() - (scratch[3].imag() *0.5) );
                Fout[m] = fcomplex_type( Fout->real() - (scratch[3].real()*0.5 ) , Fout->imag() - (scratch[3].imag() *0.5) );

                scratch[0] *= epi3.imag() ;

                *Fout+=scratch[3];

                // sglee Fout[m2] = complex_type(  Fout[m].real() + scratch[0].imag() , Fout[m].imag() - scratch[0].real() );
                Fout[m2] = fcomplex_type(  Fout[m].real() + scratch[0].imag() , Fout[m].imag() - scratch[0].real() );

                 // sglee Fout[m] += complex_type( -scratch[0].imag(),scratch[0].real() ) ;
                 Fout[m] += fcomplex_type( -scratch[0].imag(),scratch[0].real() ) ;
                ++Fout;
            }while(--k);
        }

        // sglee void bfly5( complex_type * Fout, const size_t fstride, const size_t m)
        void bfly5( fcomplex_type * Fout, const size_t fstride, const size_t m)
        {
            // sglee complex_type *Fout0,*Fout1,*Fout2,*Fout3,*Fout4;
            fcomplex_type *Fout0,*Fout1,*Fout2,*Fout3,*Fout4;
            size_t u;
            // sglee complex_type scratch[13];
            // sglee complex_type * twiddles = &_twiddles[0];
            // sglee complex_type *tw;
            // sglee complex_type ya,yb;
            fcomplex_type scratch[13];
            fcomplex_type * twiddles = &_twiddles[0];
            fcomplex_type *tw;
            fcomplex_type ya,yb;
            ya = twiddles[fstride*m];
            yb = twiddles[fstride*2*m];

            Fout0=Fout;
            Fout1=Fout0+m;
            Fout2=Fout0+2*m;
            Fout3=Fout0+3*m;
            Fout4=Fout0+4*m;

            tw=twiddles;
            for ( u=0; u<m; ++u ) {
                scratch[0] = *Fout0;

                scratch[1] =*Fout1* tw[u*fstride];
                scratch[2] =*Fout2* tw[2*u*fstride];
                scratch[3] =*Fout3* tw[3*u*fstride];
                scratch[4] =*Fout4* tw[4*u*fstride];

                scratch[7]=scratch[1]+scratch[4];
                scratch[10]=scratch[1]-scratch[4];
                scratch[8]=scratch[2]+scratch[3];
                scratch[9]=scratch[2]-scratch[3];

                *Fout0+= scratch[7];
                *Fout0+= scratch[8];

                // sglee scratch[5] = scratch[0] + complex_type(
                scratch[5] = scratch[0] + fcomplex_type(
                        (scratch[7].real()*ya.real() ) + (scratch[8].real() *yb.real() ),
                        (scratch[7].imag()*ya.real()) + (scratch[8].imag()*yb.real())
                        );

                // sglee scratch[6] =  complex_type( 
                scratch[6] =  fcomplex_type( 
                        (scratch[10].imag()*ya.imag()) + (scratch[9].imag()*yb.imag()),
                        -(scratch[10].real()*ya.imag()) - (scratch[9].real()*yb.imag()) 
                        );

                *Fout1=scratch[5]-scratch[6];
                (*Fout4)=scratch[5]+scratch[6];

                scratch[11] = scratch[0] + 
                    // sglee complex_type(
                    fcomplex_type(
                            (scratch[7].real()*yb.real()) + (scratch[8].real()*ya.real()),
                            (scratch[7].imag()*yb.real()) + (scratch[8].imag()*ya.real())
                            );

                // sglee scratch[12] = complex_type(
                scratch[12] = fcomplex_type(
                        -(scratch[10].imag()*yb.imag()) + (scratch[9].imag()*ya.imag()),
                        (scratch[10].real()*yb.imag()) - (scratch[9].real()*ya.imag())
                        );

                *Fout2=scratch[11]+scratch[12];
                *Fout3=scratch[11]-scratch[12];

                ++Fout0;++Fout1;++Fout2;++Fout3;++Fout4;
            }
        }

        /* perform the butterfly for one stage of a mixed radix FFT */
        void bfly_generic(
                // sglee complex_type * Fout,
                fcomplex_type * Fout,
                const size_t fstride,
                int m,
                int p
                )
        {
            int u,k,q1,q;
            // sglee complex_type * twiddles = &_twiddles[0];
            // sglee complex_type t;
            // sglee complex_type scratchbuf[p];
            fcomplex_type * twiddles = &_twiddles[0];
            fcomplex_type t;
            fcomplex_type scratchbuf[p];
            int Norig = _nfft;

            for ( u=0; u<m; ++u ) {
                k=u;
                for ( q1=0 ; q1<p ; ++q1 ) {
                    scratchbuf[q1] = Fout[ k  ];
                    k += m;
                }

                k=u;
                for ( q1=0 ; q1<p ; ++q1 ) {
                    int twidx=0;
                    Fout[ k ] = scratchbuf[0];
                    for (q=1;q<p;++q ) {
                        twidx += fstride * k;
                        if (twidx>=Norig) twidx-=Norig;
                        t=scratchbuf[q] * twiddles[twidx] ;
                        Fout[ k ] +=t;
                    }
                    k += m;
                }
            }
        }
    public:

        int _nfft;
        bool _inverse;
        // sglee std::vector<complex_type> _twiddles;
        std::vector<fcomplex_type> _twiddles;
        std::vector<int> _stageRadix;
        std::vector<int> _stageRemainder;
        traits_type _traits;
};
// sglee class Rfft
class Rfft_fxp
{
    public:
        // typedef fft_utils::traits traits_type;
        typedef fft_utils_fxp::traits traits_type;
        typedef traits_type::scalar_type scalar_type;
        typedef traits_type::complex_type complex_type;
        typedef traits_type::fcomplex_type fcomplex_type; // sglee 

        // sglee Rfft(int nfft,bool inverse)
        Rfft_fxp(int nfft,bool inverse)
            :_fft(nfft/2,inverse), _nfft(nfft),_inverse(inverse),_twiddles(nfft/2)
        {
        }
        void fill_super_twiddle()
        {
            int i;
            for (i = 0; i < _nfft/4; ++i) {
                _REAL phase =
                    -3.14159265358979323846264338327 * ((_REAL) (i+1) / (_nfft/2) + .5);
                if (_inverse)
                    phase *= -1;
                // sglee _twiddles[i]=complex_type(cos(phase),sin(phase));
                _twiddles[i]=fcomplex_type(FXP(cos(phase)),FXP(sin(phase)));
            }
        }

        // sglee void transform(const scalar_type * src , complex_type * dst)
        void transform(const FXP* src , fcomplex_type * dst)
        {
            int k,ncfft;
            // sglee complex_type fpnk,fpk,f1k,f2k,tw,tdc;
            fcomplex_type fpnk,fpk,f1k,f2k,tw,tdc;
            ncfft=_nfft/2;
            if(_inverse==true) fprintf(stderr,"Rfft: improper function call\n");
            // sglee complex_type* tmpbuf=new complex_type[ncfft];
            // sglee complex_type* inp=new complex_type[ncfft];
            fcomplex_type* tmpbuf=new fcomplex_type[ncfft];
            fcomplex_type* inp=new fcomplex_type[ncfft];
            fill_super_twiddle();

            for(int i=0; i<ncfft; i++)
                // sglee inp[i]=complex_type(src[2*i],src[2*i+1]);
                inp[i]=fcomplex_type(src[2*i],src[2*i+1]);

            if(_inverse==false)
            {
                _fft.transform(inp,tmpbuf);
                tdc=tmpbuf[0];
                // sglee dst[0]= complex_type(tdc.real() + tdc.imag(),0);
                // sglee dst[ncfft]=complex_type(tdc.real() - tdc.imag(),0);
                dst[0]= fcomplex_type(tdc.real() + tdc.imag(),0);
                dst[ncfft]=fcomplex_type(tdc.real() - tdc.imag(),0);

                for ( k=1;k <= ncfft/2 ; ++k ) {
                    fpk    = tmpbuf[k]; 
                    // sglee fpnk = complex_type(tmpbuf[ncfft-k].real(), -tmpbuf[ncfft-k].imag());
                    fpnk = fcomplex_type(tmpbuf[ncfft-k].real(), -tmpbuf[ncfft-k].imag());

                    f1k= fpk + fpnk ;
                     f2k= fpk - fpnk ;
                     tw = f2k * _twiddles[k-1];

                    // sglee dst[k] = complex_type((f1k.real() + tw.real())*0.5, (f1k.imag() + tw.imag())*0.5);
                    // sglee dst[ncfft-k]=complex_type((f1k.real() - tw.real())*0.5,
                    dst[k] = fcomplex_type((f1k.real() + tw.real())*0.5, (f1k.imag() + tw.imag())*0.5);
                    dst[ncfft-k]=fcomplex_type((f1k.real() - tw.real())*0.5,
                            (tw.imag() - f1k.imag())*0.5);
                }
            }
            delete [] tmpbuf;
            delete [] inp;
        }
        // sglee void itransform(const complex_type *src, scalar_type *dst)
        void itransform(const fcomplex_type *src, FXP *dst)
        {
            int k;
            int ncfft = _nfft/2;
            // sglee complex_type* tmpbuf=new complex_type[ncfft];
            // sglee complex_type* outp=new complex_type[ncfft];
            fcomplex_type* tmpbuf=new fcomplex_type[ncfft];
            fcomplex_type* outp=new fcomplex_type[ncfft];
            fill_super_twiddle();
            // sglee tmpbuf[0]= complex_type(src[0].real() + src[ncfft].real(), src[0].real() - src[ncfft].real());
            tmpbuf[0]= fcomplex_type(src[0].real() + src[ncfft].real(), src[0].real() - src[ncfft].real());
            if(_inverse==false) fprintf(stderr,"Rfft: improper function call\n");
            for (k = 1; k <= ncfft / 2; ++k) {
                // sglee complex_type fk, fnkc, fek, fok, tmp;
                fcomplex_type fk, fnkc, fek, fok, tmp;
                fk = src[k];
                // sglee fnkc = complex_type( src[ncfft - k].real(),-src[ncfft - k].imag());
                fnkc = fcomplex_type( src[ncfft - k].real(),-src[ncfft - k].imag());


                fek= fk+ fnkc;
                tmp= fk- fnkc;
                fok= tmp* _twiddles[k-1];
                tmpbuf[k]= fek+ fok;
                tmpbuf[ncfft - k]= fek- fok;

                conj(tmpbuf[ncfft - k]);
            }
            _fft.transform(tmpbuf, outp);
            for(int i=0; i<ncfft; i++)
            {
                dst[2*i]=outp[i].real();
                dst[2*i+1]=outp[i].imag();
            }

            delete [] tmpbuf;
            delete [] outp;

        }
    private:
        // these were #define macros in the original fft

        // sglee fft _fft;
        fft_fxp _fft;
        int _nfft;
        bool _inverse;
        // sglee std::vector<complex_type> _twiddles;
        std::vector<fcomplex_type> _twiddles;
};

#endif
