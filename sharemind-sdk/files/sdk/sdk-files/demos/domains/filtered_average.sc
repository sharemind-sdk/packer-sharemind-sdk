import aby;
import shared3p;
import spdz_fresco;

domain pd_aby aby;
domain pd_shared3p shared3p;
domain pd_spdz_fresco spdz_fresco;

template<domain D, type T>
D T vecSum(D T [[1]] val, D T carry) {
    assert(size(val) > 0);

    uint n = size(val);
    if (n == 1) {
        return carry + val[0];
    }

    if (n % 2 == 0) {
        return vecSum(val[0:n/2] + val[n/2:n], carry);
    } else {
        return vecSum(val[0:n/2] + val[n/2:n-1], carry + val[n-1]);
    }
}

template<domain D, type T>
D T vecSum(D T [[1]] val) {
    assert(size(val) > 0);
    D T carry = 0;
    return vecSum(val, carry);
}

template<domain D, type T>
T vecAvg(D T [[1]] val, D T [[1]] mask) {
    assert(size(val) == size(mask));
    assert(size(val) > 0);

    uint n = size(val);
    if (n == 1) {
        return declassify(val[0] * mask[0]);
    }

    val = val * mask;
    D T sum = vecSum(val);
    D T count = vecSum(mask);

    return declassify(sum) / declassify(count);
}

void main() {
    uint [[1]] pubVal = {1, 2, 11, 0, 11, 0, 8, 3, 22, 13};
    bool [[1]] pubMask = {true, false, true, false, true, false, true, false, true, false};

    { // pd_aby
        pd_aby uint64 [[1]] val = pubVal;
        pd_aby uint64 [[1]] mask = (uint) pubMask;
        uint average = vecAvg(val, mask);
        print(average);
    }
    { // pd_shared3p
        pd_shared3p uint64 [[1]] val = pubVal;
        pd_shared3p uint64 [[1]] mask = (uint) pubMask;
        uint average = vecAvg(val, mask);
        print(average);
    }
    { // pd_spdz_fresco
        pd_spdz_fresco uint64 [[1]] val = pubVal;
        pd_spdz_fresco uint64 [[1]] mask = (uint) pubMask;
        uint average = vecAvg(val, mask);
        print(average);
    }
}
