#include <iostream>
#include <stdlib.h>
#include <vector>
#include <SOIL/SOIL.h>


#define signelLength  8
#define filterLength  6

/**
 * @brief convolution1D
 * @param x
 * @param y
 * @return
 */
int* convolution1D( std::vector<int> x, std::vector<int> y );

/**
 * @brief convolution2D
 * @param x
 * @param rows
 * @param colums
 * @param h
 * @param krows
 * @param kcolumns
 * @return
 */
int* convolution2D( int *x, int rows, int colums,
                    int *h, int krows, int kcolumns );


int main()
{
    std::vector<int> x, h;

    int signal[ signelLength ] = { 1, 2, 3, 4, 1, 2, 3, 4 };
    int filter[ filterLength ] = { 3, 4, 5, 3, 3, 4 };


    std::cout << "x[n]=[ ";
    for( int i = 0; i < signelLength; i++ )
    {
        x.push_back( signal[i] );
        std::cout << signal[ i ] << " ";
    }

    std::cout << "]\nh[n]=[ ";
    for( int i = 0; i < filterLength; i++ )
    {
        h.push_back( filter[i] );
        std::cout << filter[ i ] << " ";
    }
    std::cout << "]" << std::endl;

    convolution1D( x, h );


    return EXIT_SUCCESS;
}

int* convolution1D( std::vector<int> x , std::vector<int> y )
{
    int n = x.size(); // signal
    int m = y.size(); // filter

    int length = n + m - 1;
    // in malloc use number * sizeof(type) to avoid free errors
    int* result = (int*) malloc( length * sizeof(int) );

    // perfrom summation
    for( int i = 0; i < length; i++ )
    {
        // zero padding
        if( i >= n )
            x.push_back( 0 );
        if( i >= m )
            y.push_back( 0 );

        // initialize output with zero's
        result[ i ] = 0;

        for( int k = 0; k < n; k++ )
        {
            int xN = x.at( k ); // element of signal
            int hN = 0;
            int filterIndex = i - k; // index of elements in filter

            if( filterIndex < 0 || filterIndex >= m ) // range condition
                hN = 0;
            else
                hN = y.at( filterIndex );

            result[ i ] += xN * hN ; // multiplay signal with filter
        }
    }

    // show result
    std::cout << "y[n]= x[n] * h[n] = [ " ;
    for( int i = 0; i < length ; i++ )
        std::cout << result[ i ] << " ";
    std::cout << "]"<< std::endl;

    return result;
}

int* convolution2D( int* x, int rows, int colums,
                    int* h, int krows, int kcolumns )
{
    int length = n1 * n2;
    int centerX = rows / 2;
    int centerY = colums / 2;

    for( int c = 0; c < colums; c++ )
    {
        for( int r = 0; r < rows; r++ )
        {
            for( int kc = 0; kc < kcolumns; kc++ )
            {
                for( int kr = 0; kr < krows; kr )
                {

                }
            }
        }
    }
}
