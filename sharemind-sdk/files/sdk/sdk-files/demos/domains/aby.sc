module aby;

kind aby;

/*
 * ABY supports uint types with different secret sharing schemes (arithmetic,
 * boolean and Yao's circuits). However, currently there is no easy way to add
 * new types to SecreC. This will be changed in future versions.

 * We overload some operators to call protocols for a specific secret sharing
 * scheme.
 */

template <domain D : aby, type T, dim N>
D T [[N]] operator+(D T [[N]] a, D T [[N]] b) {
    assert(size(a) == size(b));
    __syscall("aby::add_arith_$T\_vec", __domainid (D), a, b, a);
   return a;
}

template <domain D : aby, type T, dim N>
D T [[N]] operator*(D T [[N]] a, D T [[N]] b) {
    assert(size(a) == size(b));
    __syscall("aby::mul_arith_$T\_vec", __domainid (D), a, b, a);
   return a;
}

template <domain D : aby, type T, dim N>
D T [[N]] operator-(D T [[N]] a, D T [[N]] b) {
    assert(size(a) == size(b));
    __syscall("aby::sub_arith_$T\_vec", __domainid (D), a, b, a);
   return a;
}

template <domain D : aby, type T, dim N>
D T [[N]] choose(D T [[N]] cond, D T [[N]] first, D T [[N]] second) {
    D T [[N]] out = first;
    __syscall("aby::choose_arith_$T\_vec", __domainid (D), cond, first, second, out);
    return out;
}
