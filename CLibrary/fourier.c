//
//  fourier.c
//  FulliOS
//
//  Created by Yassine Lafryhi on 1/8/2024.
//

#include <math.h>

void fourier_transform(float* signal, int n, float* real, float* imag) {
    int i, k;
    float sum_real, sum_imag;

    for (k = 0; k < n; k++) {
        sum_real = 0.0;
        sum_imag = 0.0;

        for (i = 0; i < n; i++) {
            float angle = 2 * M_PI * k * i / n;
            sum_real += signal[i] * cos(angle);
            sum_imag += signal[i] * sin(angle);
        }

        real[k] = sum_real / n;
        imag[k] = sum_imag / n;
    }
}
