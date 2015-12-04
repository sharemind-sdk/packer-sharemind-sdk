/*
 This is an example code file for SecreC 2.
 It will illustrate several language concepts.

 For more information, please see http://sharemind-sdk.github.io/
 */

// We import the module for secure computing protocols based on secret
// sharing among three parties. It is a very efficient and provably
// secure method for secure computation. However, you will not have to
// understand the underlying cryptography, as all of it will be hidden
// from you while Sharemind does the heavy lifting.
import shared3p;
// We also need some public operations from the standard library
import stdlib;

// We imported the shared3p protection domain kind module above. Now we can
// use it to define individual protection domain ("instantiate the protocols").
// We declare a type pd_shared3p and use it for all values that have to be
// protected with secure computation. Sharemind then knows that these values
// must always be protected.
domain pd_shared3p shared3p;

// This is a domain-polymorphic function, specialized to the shared3p domain.
// This means that the function runs on any instance of the shared3p domain kind D.
// It is also type polymorphic, running on any type T with the necessary arithmetic operations.
// The [[1]] means that x is a one-dimensional array.
template<domain D : shared3p, type T>
D T[[1]] square_and_multiply(D T[[1]] x, int n) {

    // In Sharemind, we do not try to hide the data flow in the program.
    // We can, therefore, also use recursion.
    // There are special tricks to hide program flow. See the 'oblivious.sc'
    // module in the SecreC API.

    if (n < 0) {
        // Note that SecreC has built-in pointwise operations on arrays.
        // Constants are automatically expanded to the necessary size and
        // converted to the private type automatically.
        // The inverse conversion is not automatic. See below.
        return square_and_multiply(1 / x, -n);
    } else if (n == 0) {
        // Again, see how the whole array is initialized to the constant 1.
        // This makes data mining algorithms much easier to implement.
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

// SecreC and Sharemind effortlessly combine public and private data.
// Public data is processed without encryption for efficiency. This
// allows algorithms that balance performance with privacy.
void uint64_test(uint s) {

    // Print is for logging only. In the actual Sharemind, it produces
    // a server log that is not necessarily sent to the user.
    print("Running test for type: uint64");

    // Here we declare an array of private integers of size s.
    pd_shared3p uint64[[1]] input(s);

    // Note that s is public. SecreC currently does not let you use private
    // conditions in loop invariants.
    for (uint i = 0; i < s; ++i)
        input[i] = i + 1;

    // Here you see the declassify operator. It is the only way for making
    // private data public. Also - because it is so explicit, it is easy to
    // find all possible data leaks in the code.
    // Also note the range syntax for extracting a subset of the array.
    print("Inputs:");
    printVector(declassify(input[0:min(s, 10::uint)]));

    // Here, SecreC matches the function call to the template above
    // and runs the code on the pd_shared3p domain instantiated in Sharemind.
    pd_shared3p uint64[[1]] output = square_and_multiply(input, 3);

    print("Outputs:");
    printVector(declassify(output[0:min(s, 10::uint)]));
}

// The same, just for floating point numbers
void float64_test(uint s) {
    print("Running test for type: float64");
    pd_shared3p float64[[1]] input(s);

    for (uint i = 0; i < s; ++i)
        input[i] = (float64)(i + 1) / 2;

    print("Inputs:");
    printVector(declassify(input[0:min(s, 10::uint)]));

    // Note that we are using the same polymorphic function with
    // the same domain, but with a different data type.
    pd_shared3p float64[[1]] output = square_and_multiply(input, 3);
    print("Outputs:");
    printVector(declassify(output[0:min(s, 10::uint)]));
}

// The classical entry point to the program
void main() {
    uint s = 100000;

    print("Vector size: ", s);

    uint64_test(s);
    float64_test(s);
}
