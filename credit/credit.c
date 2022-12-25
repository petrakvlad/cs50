#include <cs50.h>
#include <stdio.h>
#include <math.h>

int main(void)
{
    // Input from user
    long card_number = get_long("Enter the card number: ");
    int i = 0;
    long cc = card_number;
    while(cc > 0)
    {
        cc = cc/10;
        i++;
    }
    printf("Number of digits: %i\n", i);

    // Check if length is valid
    if (i != 13 && i != 15 && i != 16)
    {
        printf("Invalid card\n");
        return 0;
    }

    // Calculate checksum
    long xx = card_number;
    int sum1 = 0;
    int sum2 = 0;
    int mod1 = 0;
    int mod2 = 0;
    int total = 0;
    int d1;
    int d2;

    do
    {
    //Remove last digit and add to sum1
    mod1 = xx % 10;
    sum1 = sum1 + mod1;
    xx = xx / 10;

    //Remove second last digit
    mod2 = xx % 10;
    xx = xx / 10;

    //Double second last digit and add digits to sum2
    mod2 = mod2 * 2;
    d1 = mod2 % 10;
    d2 = mod2 / 10;
    sum2 = sum2 + d1 + d2;
    }
    while (xx > 0);

    total = sum1 + sum2;

    // Check Luhn algorithm
    if (total % 10 != 0)
    {
        printf("Luhn proof - Invalid\n");
        return 0;
    }
    // Get starting digits
    long start = card_number;
    do
    {
        start = start /10;
    }
    while (start > 100);

    // Now check starting digits for card type
    if ((start / 10 == 5) && ((start % 10 > 0) && (start % 10 < 6)))
    {
        printf("Mastercard\n");
    }
    else if ((start / 10 == 3) && ((start % 10 ==4) || (start % 10 == 7)))
    {
        printf("Amex\n");
    }
    else if (start / 10 == 4)
    {
        printf("Visa\n");
    }
    else
    {
        printf("Card type - Invalid\n");
    }

}
