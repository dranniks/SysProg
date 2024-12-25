#include <math.h>

double exact_value(double x) {
    return (0.25 * log((1 + x) / (1 - x))) + (0.5 * atan(x));
}

double power(double x, int exponent) {
    return pow(x, exponent);
}