def find_root(func, tolerance):
    l, r = 1, 3
    while r - l > tolerance:
        m = (l + r) / 2
        if func(l)*func(m) <= 0:
            r = m
        else:
            l = m
    return l


def f(x):
    return x**3 - 0.5*x**2 + 0.2*x - 4


if __name__ == '__main__':
    eps = float(input())
    print(find_root(f, eps))
