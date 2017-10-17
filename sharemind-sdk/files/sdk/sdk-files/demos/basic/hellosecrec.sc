import shared3p;
import stdlib;

domain pd_shared3p shared3p;

template<domain D : shared3p, type T>
D T[[1]] square_and_multiply(D T[[1]] x, int n) {
    if (n < 0) {
        return square_and_multiply(1 / x, -n);
    } else if (n == 0) {
	D T[[1]] rv(size(x)) = 1;
        return rv;
    } else if (n == 1) {
        return x;
    } else if (n % 2 == 0) {
        return square_and_multiply(x * x, n / 2);
    } else {
        return x * square_and_multiply(x * x, (n - 1) / 2);
    }
}

void uint64_test(uint s) {
    print("Running test for type: uint64");
    pd_shared3p uint64[[1]] input(s);

    for (uint i = 0; i < s; ++i)
        input[i] = i + 1;

    print("Inputs:");
    printVector(declassify(input[0:min(s, 10::uint)]));

    pd_shared3p uint64[[1]] output = square_and_multiply(input, 3);
    print("Outputs:");
    printVector(declassify(output[0:min(s, 10::uint)]));
}

void float64_test(uint s) {
    print("Running test for type: float64");
    pd_shared3p float64[[1]] input(s);

    for (uint i = 0; i < s; ++i)
        input[i] = (float64)(i + 1) / 2;

    print("Inputs:");
    printVector(declassify(input[0:min(s, 10::uint)]));

    pd_shared3p float64[[1]] output = square_and_multiply(input, 3);
    print("Outputs:");
    printVector(declassify(output[0:min(s, 10::uint)]));
}

void main() {
    uint s = 100;

    print("Vector size: ", s);

    uint64_test(s);
    float64_test(s);
}
