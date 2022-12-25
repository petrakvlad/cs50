#include "helpers.h"
#include  <math.h>
#include <stdlib.h>


int calc (int x);

// Convert image to grayscale
void grayscale(int height, int width, RGBTRIPLE image[height][width])
{
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            int col = round((image[i][j].rgbtBlue + image[i][j].rgbtGreen + image[i][j].rgbtRed) / 3.0);
            image[i][j].rgbtBlue = col;
            image[i][j].rgbtGreen = col;
            image[i][j].rgbtRed = col;
        }
    }
    return;
}

// Reflect image horizontally
void reflect(int height, int width, RGBTRIPLE image[height][width])
{
    RGBTRIPLE(*imageref)[width] = calloc(height, width * sizeof(RGBTRIPLE));
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            imageref[i][j] = image[i][width-j];
        }
    }

    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            image[i][j] = imageref[i][j];
        }
    }
    free(imageref);
    return;
}


// Blur image
void blur(int height, int width, RGBTRIPLE image[height][width])
{
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            int count = 0;
            int avblue = 0;
            int avgreen = 0;
            int avred = 0;
            for (int n = 0; n < 3; n++)
            {
                for (int k = 0; k < 3; k++)
                {
                    if(i - 1 + n < 0 || j - 1 + k < 0 || i - 1 + n > height || j - 1 + k > width)
                    {
                        continue;
                    }
                    avblue = avblue + image[i - 1 + n][j - 1 + k].rgbtBlue;
                    avgreen = avgreen + image[i - 1 + n][j - 1 + k].rgbtGreen;
                    avred = avred + image[i - 1 + n][j - 1 + k].rgbtRed;
                    count++;
                }
            }


            image[i][j].rgbtBlue = round(avblue/count);
            image[i][j].rgbtGreen = round(avgreen/count);
            image[i][j].rgbtRed = round(avred/count);
        }
    }
    return;
}

// Detect edges
void edges(int height, int width, RGBTRIPLE image[height][width])
{

    RGBTRIPLE temp[height][width];
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            temp[i][j] = image[i][j];
        }
    }

    int gxm[3][3] = {{-1, 0, 1}, {-2, 0, 2}, {-1, 0, 1}};
    int gym[3][3] = {{-1, -2, -1}, {0, 0, 0}, {1, 2, 1}};

    for (int i = 1; i < height - 1; i++)
    {
        for (int j = 1; j < width - 1; j++)
        {
            int bluex = 0;
            int greenx = 0;
            int redx = 0;
            int bluey = 0;
            int greeny = 0;
            int redy = 0;

            for (int n = 0; n < 3; n++)
            {
                for (int k = 0; k < 3; k++)
                {
                    if(i - 1 + n < 0 || j - 1 + k < 0 || i - 1 + n > height - 1 || j - 1 + k > width -1)
                    {
                        continue;
                    }
                    bluex = bluex + temp[i - 1 + n][j - 1 + k].rgbtBlue * gxm[n][k];
                    greenx = greenx + temp[i - 1 + n][j - 1 + k].rgbtGreen * gxm[n][k];
                    redx =  redx + temp[i - 1 + n][j - 1 + k].rgbtRed * gxm[n][k];
                    bluey = bluey + temp[i - 1 + n][j - 1 + k].rgbtBlue * gym[n][k];
                    greeny = greeny + temp[i - 1 + n][j - 1 + k].rgbtGreen * gym[n][k];
                    redy = redy + temp[i - 1 + n][j - 1 + k].rgbtRed * gym[n][k];
                }
            }
            image[i][j].rgbtBlue = calc(round(sqrt(bluex*bluex + bluey*bluey)));
            image[i][j].rgbtGreen = calc(round(sqrt(greenx*greenx + greeny*greeny)));
            image[i][j].rgbtRed = calc(round(sqrt(redx*redx + redy*redy)));
        }
    }
    return;
}

int calc (int x)
{
    if (x > 255)
        return 255;
    else
        return x;
}