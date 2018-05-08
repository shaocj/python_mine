
一是必选参数在前，默认参数在后，否则Python的解释器会报错（思考一下为什么默认参数不能放在必选参数前面）；
 定义默认参数要牢记一点：默认参数必须指向不变对象！

def add_end(L=[]):

    L.append('END')

    return L

但是，再次调用add_end()时，结果就不对了：

>>> add_end()

['END', 'END']

>>> add_end()

['END', 'END', 'END']

Python函数在定义的时候，默认参数L的值就被计算出来了，即[]，因为默认参数L也是一个变量，它指向对象[]，每次调用该函数，如果改变了L的内容，则下次调用时，默认参数的内容就变了，不再是函数定义时的[]了。

修改上面的例子，我们可以用None这个不变对象来实现：

def add_end(L=None):

    if L is None:

        L = []

    L.append('END')

    return L

现在，无论调用多少次，都不会有问题：

>>> add_end()

['END']

>>> add_end()

['END']

为什么要设计str、None这样的不变对象呢？因为不变对象一旦创建，对象内部的数据就不能修改，这样就减少了由于修改数据导致的错误。此外，由于对象不变，多任务环境下同时读取对象不需要加锁，同时读一点问题都没有。我们在编写程序时，如果可以设计一个不变对象，那就尽量设计成不变对象

函数的参数

定义函数的时候，我们把参数的名字和位置确定下来，函数的接口定义就完成了。对于函数的调用者来说，只需要知道如何传递正确的参数，以及函数将返回什么样的值就够了，函数内部的复杂逻辑被封装起来，调用者无需了解。

Python的函数定义非常简单，但灵活度却非常大。除了正常定义的必选参数外，还可以使用默认参数、可变参数和关键字参数，使得函数定义出来的接口，不但能处理复杂的参数，还可以简化调用者的代码。

位置参数

我们先写一个计算x2的函数：


def power(x):

    return x * x
    
对于power(x)函数，参数x就是一个位置参数。

当我们调用power函数时，必须传入有且仅有的一个参数x：


>>> power(5)

25
>>> power(15)
225
现在，如果我们要计算x3怎么办？可以再定义一个power3函数，但是如果要计算x4、x5……怎么办？我们不可能定义无限多个函数。

你也许想到了，可以把power(x)修改为power(x, n)，用来计算xn，说干就干：

def power(x, n):
    s = 1
    while n > 0:
        n = n - 1
        s = s * x
    return s
对于这个修改后的power(x, n)函数，可以计算任意n次方：

>>> power(5, 2)
25
>>> power(5, 3)
125
修改后的power(x, n)函数有两个参数：x和n，这两个参数都是位置参数，调用函数时，传入的两个值按照位置顺序依次赋给参数x和n。

默认参数

新的power(x, n)函数定义没有问题，但是，旧的调用代码失败了，原因是我们增加了一个参数，导致旧的代码因为缺少一个参数而无法正常调用：

>>> power(5)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: power() missing 1 required positional argument: 'n'
Python的错误信息很明确：调用函数power()缺少了一个位置参数n。

这个时候，默认参数就排上用场了。由于我们经常计算x2，所以，完全可以把第二个参数n的默认值设定为2：

def power(x, n=2):
    s = 1
    while n > 0:
        n = n - 1
        s = s * x
    return s
这样，当我们调用power(5)时，相当于调用power(5, 2)：

>>> power(5)
25
>>> power(5, 2)
25
而对于n > 2的其他情况，就必须明确地传入n，比如power(5, 3)。

从上面的例子可以看出，默认参数可以简化函数的调用。设置默认参数时，有几点要注意：

一是必选参数在前，默认参数在后，否则Python的解释器会报错（思考一下为什么默认参数不能放在必选参数前面）；

二是如何设置默认参数。

当函数有多个参数时，把变化大的参数放前面，变化小的参数放后面。变化小的参数就可以作为默认参数。

使用默认参数有什么好处？最大的好处是能降低调用函数的难度。

举个例子，我们写个一年级小学生注册的函数，需要传入name和gender两个参数：

def enroll(name, gender):
    print('name:', name)
    print('gender:', gender)
这样，调用enroll()函数只需要传入两个参数：

>>> enroll('Sarah', 'F')
name: Sarah
gender: F
如果要继续传入年龄、城市等信息怎么办？这样会使得调用函数的复杂度大大增加。

我们可以把年龄和城市设为默认参数：

def enroll(name, gender, age=6, city='Beijing'):
    print('name:', name)
    print('gender:', gender)
    print('age:', age)
    print('city:', city)
这样，大多数学生注册时不需要提供年龄和城市，只提供必须的两个参数：

>>> enroll('Sarah', 'F')
name: Sarah
gender: F
age: 6
city: Beijing
只有与默认参数不符的学生才需要提供额外的信息：

enroll('Bob', 'M', 7)
enroll('Adam', 'M', city='Tianjin')
可见，默认参数降低了函数调用的难度，而一旦需要更复杂的调用时，又可以传递更多的参数来实现。无论是简单调用还是复杂调用，函数只需要定义一个。

有多个默认参数时，调用的时候，既可以按顺序提供默认参数，比如调用enroll('Bob', 'M', 7)，意思是，除了name，gender这两个参数外，最后1个参数应用在参数age上，city参数由于没有提供，仍然使用默认值。

也可以不按顺序提供部分默认参数。当不按顺序提供部分默认参数时，需要把参数名写上。比如调用enroll('Adam', 'M', city='Tianjin')，意思是，city参数用传进去的值，其他默认参数继续使用默认值。

默认参数很有用，但使用不当，也会掉坑里。默认参数有个最大的坑，演示如下：

先定义一个函数，传入一个list，添加一个END再返回：

def add_end(L=[]):
    L.append('END')
    return L
当你正常调用时，结果似乎不错：

>>> add_end([1, 2, 3])
[1, 2, 3, 'END']
>>> add_end(['x', 'y', 'z'])
['x', 'y', 'z', 'END']
当你使用默认参数调用时，一开始结果也是对的：

>>> add_end()
['END']
但是，再次调用add_end()时，结果就不对了：

>>> add_end()
['END', 'END']
>>> add_end()
['END', 'END', 'END']
很多初学者很疑惑，默认参数是[]，但是函数似乎每次都“记住了”上次添加了'END'后的list。

原因解释如下：

Python函数在定义的时候，默认参数L的值就被计算出来了，即[]，因为默认参数L也是一个变量，它指向对象[]，每次调用该函数，如果改变了L的内容，则下次调用时，默认参数的内容就变了，不再是函数定义时的[]了。

 定义默认参数要牢记一点：默认参数必须指向不变对象！
要修改上面的例子，我们可以用None这个不变对象来实现：

def add_end(L=None):
    if L is None:
        L = []
    L.append('END')
    return L
现在，无论调用多少次，都不会有问题：

>>> add_end()
['END']
>>> add_end()
['END']
为什么要设计str、None这样的不变对象呢？因为不变对象一旦创建，对象内部的数据就不能修改，这样就减少了由于修改数据导致的错误。此外，由于对象不变，多任务环境下同时读取对象不需要加锁，同时读一点问题都没有。我们在编写程序时，如果可以设计一个不变对象，那就尽量设计成不变对象。

可变参数

在Python函数中，还可以定义可变参数。顾名思义，可变参数就是传入的参数个数是可变的，可以是1个、2个到任意个，还可以是0个。

我们以数学题为例子，给定一组数字a，b，c……，请计算a2 + b2 + c2 + ……。

要定义出这个函数，我们必须确定输入的参数。由于参数个数不确定，我们首先想到可以把a，b，c……作为一个list或tuple传进来，这样，函数可以定义如下：

def calc(numbers):
    sum = 0
    for n in numbers:
        sum = sum + n * n
    return sum
但是调用的时候，需要先组装出一个list或tuple：

>>> calc([1, 2, 3])
14
>>> calc((1, 3, 5, 7))
84
 如果利用可变参数，调用函数的方式可以简化成这样：

>>> calc(1, 2, 3)
14
>>> calc(1, 3, 5, 7)
84
所以，我们把函数的参数改为可变参数：

def calc(*numbers):
    sum = 0
    for n in numbers:
        sum = sum + n * n
    return sum
定义可变参数和定义一个list或tuple参数相比，仅仅在参数前面加了一个*号。在函数内部，参数numbers接收到的是一个tuple，因此，函数代码完全不变。但是，调用该函数时，可以传入任意个参数，包括0个参数：

>>> calc(1, 2)
5
>>> calc()
0
如果已经有一个list或者tuple，要调用一个可变参数怎么办？可以这样做：

>>> nums = [1, 2, 3]
>>> calc(nums[0], nums[1], nums[2])
14
这种写法当然是可行的，问题是太繁琐，所以Python允许你在list或tuple前面加一个*号，把list或tuple的元素变成可变参数传进去：

>>> nums = [1, 2, 3]
>>> calc(*nums)
14
*nums表示把nums这个list的所有元素作为可变参数传进去。这种写法相当有用，而且很常见。


 关键字参数

可变参数允许你传入0个或任意个参数，这些可变参数在函数调用时自动组装为一个tuple。而关键字参数允许你传入0个或任意个含参数名的参数，这些关键字参数在函数内部自动组装为一个dict。请看示例：

def person(name, age, **kw):
    print('name:', name, 'age:', age, 'other:', kw)
函数person除了必选参数name和age外，还接受关键字参数kw。在调用该函数时，可以只传入必选参数：

>>> person('Michael', 30)
name: Michael age: 30 other: {}
也可以传入任意个数的关键字参数：

>>> person('Bob', 35, city='Beijing')
name: Bob age: 35 other: {'city': 'Beijing'}
>>> person('Adam', 45, gender='M', job='Engineer')
name: Adam age: 45 other: {'gender': 'M', 'job': 'Engineer'}
>>> extra = {'city': 'Beijing', 'job': 'Engineer'}
>>> person('Jack', 24, **extra)
name: Jack age: 24 other: {'city': 'Beijing', 'job': 'Engineer'}
**extra表示把extra这个dict的所有key-value用关键字参数传入到函数的**kw参数，kw将获得一个dict，注意kw获得的dict是extra的一份拷贝，对kw的改动不会影响到函数外的extra。

命名关键字参数

对于关键字参数，函数的调用者可以传入任意不受限制的关键字参数。至于到底传入了哪些，就需要在函数内部通过kw检查。

仍以person()函数为例，我们希望检查是否有city和job参数：
 
def person(name, age, **kw):

    if 'city' in kw:

        # 有city参数

        pass

    if 'job' in kw:

        # 有job参数

        pass

    print('name:', name, 'age:',
age, 'other:', kw)

但是调用者仍可以传入不受限制的关键字参数：
>>> person('Jack', 24,
city='Beijing', addr='Chaoyang', zipcode=123456)

如果要限制关键字参数的名字，就可以用命名关键字参数，例如，只接收city和job作为关键字参数。这种方式定义的函数如下：

def person(name, age, *, city, job):

    print(name, age, city, job)

和关键字参数**kw不同，命名关键字参数需要一个特殊分隔符*，*后面的参数被视为命名关键字参数。

调用方式如下：
>>> person('Jack', 24,
city='Beijing', job='Engineer')

Jack 24 Beijing Engineer

如果函数定义中已经有了一个可变参数，后面跟着的命名关键字参数就不再需要一个特殊分隔符*了：

 

def person(name, age, *args, city, job):

    print(name, age, args, city,
job)

命名关键字参数必须传入参数名，这和位置参数不同。如果没有传入参数名，调用将报错：

 

>>> person('Jack', 24, 'Beijing',
'Engineer')

Traceback (most recent call last):

  File "<stdin>", line
1, in <module>

TypeError: person() takes 2 positional
arguments but 4 were given

由于调用时缺少参数名city和job，Python解释器把这4个参数均视为位置参数，但person()函数仅接受2个位置参数。

 

命名关键字参数可以有缺省值，从而简化调用：

 

def person(name, age, *, city='Beijing',
job):

    print(name, age, city, job)

由于命名关键字参数city具有默认值，调用时，可不传入city参数：

 

>>> person('Jack', 24,
job='Engineer')

Jack 24 Beijing Engineer

使用命名关键字参数时，要特别注意，如果没有可变参数，就必须加一个*作为特殊分隔符。如果缺少*，Python解释器将无法识别位置参数和命名关键字参数：

 

def person(name, age, city, job):

    # 缺少 *，city和job被视为位置参数

    pass

但是请注意，参数定义的顺序必须是：必选参数、默认参数、可变参数、命名关键字参数和关键字参数。

 

*args是可变参数，args接收的是一个tuple；

 

**kw是关键字参数，kw接收的是一个dict。

 

以及调用函数时如何传入可变参数和关键字参数的语法：

 

可变参数既可以直接传入：func(1,
2, 3)，又可以先组装list或tuple，再通过*args传入：func(*(1,
2, 3))；

 

关键字参数既可以直接传入：func(a=1,
b=2)，又可以先组装dict，再通过**kw传入：func(**{'a': 1, 'b': 2})。

 

使用*args和**kw是Python的习惯写法，当然也可以用其他参数名，但最好使用习惯用法。

 

使用递归函数需要注意防止栈溢出。在计算机中，函数调用是通过栈（stack）这种数据结构实现的，每当进入一个函数调用，栈就会加一层栈帧，每当函数返回，栈就会减一层栈帧。由于栈的大小不是无限的，所以，递归调用的次数过多，会导致栈溢出。可以试试fact(1000)：
>>> fact(1000)

Traceback (most recent call last):

  File "<stdin>", line
1, in <module>

  File "<stdin>", line
4, in fact

  ...

  File "<stdin>", line
4, in fact

RuntimeError: maximum recursion depth
exceeded in comparison

解决递归调用栈溢出的方法是通过尾递归优化，事实上尾递归和循环的效果是一样的，所以，把循环看成是一种特殊的尾递归函数也是可以的。

 

尾递归是指，在函数返回的时候，调用自身本身，并且，return语句不能包含表达式。这样，编译器或者解释器就可以把尾递归做优化，使递归本身无论调用多少次，都只占用一个栈帧，不会出现栈溢出的情况。

 

上面的fact(n)函数由于return n * fact(n - 1)引入了乘法表达式，所以就不是尾递归了。要改成尾递归方式，需要多一点代码，主要是要把每一步的乘积传入到递归函数中：
def fact(n):

    return fact_iter(n, 1)
def fact_iter(num, product):

    if num == 1:

        return product

    return fact_iter(num - 1, num
* product)

可以看到，return
fact_iter(num - 1, num * product)仅返回递归函数本身，num - 1和num * product在函数调用前就会被计算，不影响函数调用。

>>> d = {'a': 1, 'b': 2, 'c': 3}

>>> for key in d:

...     print(key)

...

a

c

b

因为dict的存储不是按照list的方式顺序排列，所以，迭代出的结果顺序很可能不一样。

默认情况下，dict迭代的是key。如果要迭代value，可以用for value in d.values()，如果要同时迭代key和value，可以用for k, v in d.items()。
######

默认情况下，dict迭代的是key。如果要迭代value，可以用for
value in d.values()，如果要同时迭代key和value，可以用for
k, v in d.items()。

，如何判断一个对象是可迭代对象呢？方法是通过collections模块的Iterable类型判断：

>>> from collections import Iterable

>>> isinstance('abc', Iterable) # str是否可迭代

True

>>> isinstance([1,2,3], Iterable) # list是否可迭代

True

>>> isinstance(123, Iterable) # 整数是否可迭代

False

Python内置的enumerate函数可以把一个list变成索引-元素对，这样就可以在for循环中同时迭代索引和元素本身：

>>> for i, value in enumerate(['A', 'B', 'C']):

...     print(i,
value)

...

0 A

1 B

2 C

使用内建的isinstance函数可以判断一个变量是不是字符串：

>>> x = 'abc'

>>> y = 123

>>> isinstance(x, str)

True

>>> isinstance(y, str)

False

生成器：generator。

要创建一个generator，有很多种方法。第一种方法很简单，只要把一个列表生成式的[]改成()，就创建了一个generator：

>>> L = [x * x for x in range(10)]

>>> L

[0, 1, 4, 9, 16, 25, 36, 49, 64, 81]

>>> g = (x * x for x in range(10))

>>> g

<generator object <genexpr> at 0x1022ef630>

创建L和g的区别仅在于最外层的[]和()，L是一个list，而g是一个generator

斐波拉契数列用列表生成式写不出来，但是，用函数把它打印出来却很容易：

def fib(max):

    n, a, b = 0, 0,
1

    while n <
max:

        print(b)

        a, b = b, a
+ b

        n = n + 1

    return 'done'

fib函数实际上是定义了斐波拉契数列的推算规则，可以从第一个元素开始，推算出后续任意的元素，这种逻辑其实非常类似generator。

也就是说，上面的函数和generator仅一步之遥。要把fib函数变成generator，只需要把print(b)改为yield b就可以了：

def fib(max):

    n, a, b = 0, 0,
1

    while n <
max:

        yield b

        a, b = b, a
+ b

        n = n + 1

    return 'done'

最难理解的就是generator和函数的执行流程不一样。函数是顺序执行，遇到return语句或者最后一行函数语句就返回。而变成generator的函数，在每次调用next()的时候执行，遇到yield语句返回，再次执行时从上次返回的yield语句处继续执行。

最难理解的就是generator和函数的执行流程不一样。函数是顺序执行，遇到return语句或者最后一行函数语句就返回。而变成generator的函数，在每次调用next()的时候执行，遇到yield语句返回，再次执行时从上次返回的yield语句处继续执行。

举个简单的例子，定义一个generator，依次返回数字1，3，5：

def odd():

    print('step 1')

    yield 1

    print('step 2')

    yield(3)

    print('step 3')

    yield(5)

调用该generator时，首先要生成一个generator对象，然后用next()函数不断获得下一个返回值：

>>> o = odd()

>>> next(o)

step 1

1

>>> next(o)

step 2

3

>>> next(o)

step 3

5

但是用for循环调用generator时，发现拿不到generator的return语句的返回值。如果想要拿到返回值，必须捕获StopIteration错误，返回值包含在StopIteration的value中：

>>> g = fib(6)

>>> while True:

...     try:

...         x =
next(g)

...         print('g:',
x)

...     except StopIteration
as e:

...         print('Generator
return value:', e.value)

...         break

...

g: 1

g: 1

g: 2

g: 3

g: 5

g: 8

Generator return value: done

#将杨辉三角的每一行看成一个list,写一个生成器（generator）,不断输出下一行list

def triangles(): 

ret = [1]

 while len(ret)-1 < 10:

 yield ret 

ret = [ ret[i] + ret[i+1] for i in range(len(ret)-1)] 

ret.insert(0,1) 

ret.append(1)

n = 0

results = []

for t in triangles():

    print(t)

   
results.append(t)

    n = n + 1

    if n == 10:

        break

if results == [

    [1],

    [1, 1],

    [1, 2, 1],

    [1, 3, 3,
1],

    [1, 4, 6, 4,
1],

    [1, 5, 10,
10, 5, 1],

    [1, 6, 15,
20, 15, 6, 1],

    [1, 7, 21,
35, 35, 21, 7, 1],

    [1, 8, 28,
56, 70, 56, 28, 8, 1],

    [1, 9, 36,
84, 126, 126, 84, 36, 9, 1]

]:

    print('测试通过!')

else:

print('测试失败!')

可以使用isinstance()判断一个对象是否是Iterable对象：

>>> from collections import Iterable

>>> isinstance([], Iterable)

True

>>> isinstance({}, Iterable)

True

>>> isinstance('abc', Iterable)

True

可以被next()函数调用并不断返回下一个值的对象称为迭代器：Iterator。

可以使用isinstance()判断一个对象是否是Iterator对象：

>>> from collections import Iterator

>>> isinstance((x for x in range(10)), Iterator)

True

>>> isinstance([], Iterator)

False

>>> isinstance({}, Iterator)

False

>>> isinstance('abc', Iterator)

False

生成器都是Iterator对象，但list、dict、str虽然是Iterable，却不是Iterator。

把list、dict、str等Iterable变成Iterator可以使用iter()函数：

>>> isinstance(iter([]), Iterator)

True

>>> isinstance(iter('abc'), Iterator)

True

小结

凡是可作用于for循环的对象都是Iterable类型；

凡是可作用于next()函数的对象都是Iterator类型，它们表示一个惰性计算的序列；

集合数据类型如list、dict、str等是Iterable但不是Iterator，不过可以通过iter()函数获得一个Iterator对象。

Python的for循环本质上就是通过不断调用next()函数实现的，例如：

for x in [1, 2, 3, 4, 5]:

    pass

实际上完全等价于：

# 首先获得Iterator对象:

it = iter([1, 2, 3, 4, 5])

# 循环:

while True:

    try:

        # 获得下一个值:

        x =
next(it)

    except
StopIteration:

        # 遇到StopIteration就退出循环

        break

 

 

高阶函数

map()函数接收两个参数，一个是函数，一个是Iterable，map将传入的函数依次作用到序列的每个元素，并把结果作为新的Iterator返回。

举例说明，比如我们有一个函数f(x)=x2，要把这个函数作用在一个list [1, 2, 3, 4, 5, 6, 7, 8, 9]上，就可以用map()实现如下：

>>> def f(x):

...     return x *
x

...

>>> r = map(f, [1, 2, 3, 4, 5, 6, 7, 8, 9])

>>> list(r)

[1, 4, 9, 16, 25, 36, 49, 64, 81]

如果考虑到字符串str也是一个序列，对上面的例子稍加改动，配合map()，我们就可以写出把str转换为int的函数：

>>> from functools import reduce

>>> def fn(x, y):

...     return x * 10
+ y

...

>>> def char2num(s):

...     digits = {'0':
0, '1': 1, '2': 2, '3': 3, '4': 4, '5': 5, '6': 6, '7': 7, '8': 8, '9': 9}

...     return
digits[s]

...

>>> reduce(fn, map(char2num, '13579'))

13579

filter()也接收一个函数和一个序列。和map()不同的是，filter()把传入的函数依次作用于每个元素，然后根据返回值是True还是False决定保留还是丢弃该元素。

例如，在一个list中，删掉偶数，只保留奇数，可以这么写：

def is_odd(n):

    return n % 2 ==
1

 

list(filter(is_odd, [1, 2, 4, 5, 6, 9, 10, 15]))

# 结果: [1, 5, 9,
15]

 

迭代器的一大优点是不要求事先准备好整个迭代过程中所有的元素。迭代器仅仅在迭代到某个元素时才计算该元素，而在这之前或之后，元素可以不存在或者被销毁

迭代器有两个基本的方法


 next方法：返回迭代器的下一个元素
 __iter__方法：返回迭代器对象本身


Iterator继承自Iterable，从下面的测试中可以很方便的看到Iterator包含__iter()和next()方法，而Iteratble仅仅包含iter__()。

iterable需要包含有__iter()方法用来返回iterator，而iterator需要包含有next__()方法用来被循环

如果我们自己定义迭代器，只要在类里面定义一个 iter() 函数，用它来返回一个带 next() 方法的对象就够了。

Python内置的sorted()函数就可以对list进行排序：

>>> sorted([36, 5, -12, 9, -21])

[-21, -12, 5, 9, 36]

返回一个函数时，牢记该函数并未执行，返回函数中不要引用任何可能会变化的变量。

装饰器

今天整理装饰器，内嵌的装饰器、让装饰器带参数等多种形式，非常复杂，让人头疼不已。但是突然间发现了装饰器的奥秘，原来如此简单。。。。
第一步 ：从最简单的例子开始
# -*- coding:gbk -*-
'''示例1: 使用语法糖@来装饰函数，相当于“myfunc = deco(myfunc)”
但发现新函数只在第一次被调用，且原函数多调用了一次'''
def deco(func):
    print("before myfunc() called.")
    func()
    print("  after myfunc() called.")
    return func

@deco
def myfunc():
    print(" myfunc() called.")
myfunc()
myfunc()
输出：
before myfunc() called.
 myfunc() called.
  after myfunc() called.
 myfunc() called.
 myfunc() called.
这是一个最简单的装饰器的例子，但是这里有一个问题，就是当我们两次调用myfunc()的时候，发现装饰器函数只被调用了一次。为什么会这样呢？要解释这个就要给出破解装饰器的关键钥匙了。 
这里@deco这一句，和myfunc = deco(myfunc)其实是完全等价的，只不过是换了一种写法而已 
一定要记住上面这句！！！！ 
好了，从现在开始，只需要做替换操作就可以了。 
将@deco 替换为 myfunc = deco(myfunc) 
程序首先调用deco(myfunc)，得到的返回结果赋值给了myfunc （注意：在Python中函数名只是个指向函数首地址的函数指针而已） 
而deco(myfunc)的返回值就是函数myfunc()的地址 
这样其实myfunc 没有变化，也就是说，最后的两次myfunc()函数调用，其实都没有执行到deco()。 
有同学就问了，明明打印了deco()函数里面的内容啊，怎么说没有调用到呢。这位同学一看就是没有注意听讲，那一次打印是在@deco 这一句被执行的。大家亲自动手试一下就会发现” myfunc() called.” 这句打印输出了三次。多的那次就是@deco这里输出的，因为@deco 等价于myfunc = deco(myfunc)，这里已经调用了deco()函数了。
第二步 ：确保装饰器被调用
怎么解决装饰器没有被调用的问题呢
# -*- coding:gbk -*-
'''示例2: 使用内嵌包装函数来确保每次新函数都被调用，
内嵌包装函数的形参和返回值与原函数相同，装饰函数返回内嵌包装函数对象'''

def deco(func):
    def _deco():
        print("before myfunc() called.")
        func()
        print("  after myfunc() called.")
        # 不需要返回func，实际上应返回原函数的返回值
    return _deco
@deco
def myfunc():
    print(" myfunc() called.")
    return 'ok'
myfunc()
myfunc()
输出：
before myfunc() called.
 myfunc() called.
  after myfunc() called.
before myfunc() called.
 myfunc() called.
  after myfunc() called.
这里其实不需要我解释了，还是按照第一步中的方法做替换就可以了。还是啰嗦几句吧。。 
@deco 替换为 myfunc = deco(myfunc) 
程序首先调用deco(myfunc)，得到的返回结果赋值给了myfunc ，这样myfunc 就变成了指向函数_deco()的指针 
以后的myfunc()，其实是调用_deco()
第三步 ：对带参数的函数进行装饰
破案过程和第一步、第二步完全一致，不再重复了
# -*- coding:gbk -*-
'''示例5: 对带参数的函数进行装饰，
内嵌包装函数的形参和返回值与原函数相同，装饰函数返回内嵌包装函数对象'''
def deco(func):
    def _deco(a, b):
        print("before myfunc() called.")
        ret = func(a, b)
        print("  after myfunc() called. result: %s" % ret)
        return ret
    return _deco
@deco
def myfunc(a, b):
    print(" myfunc(%s,%s) called." % (a, b))
    return a + b
myfunc(1, 2)
myfunc(3, 4)
输出：before myfunc() called.
 myfunc(1,2) called.
  after myfunc() called. result: 3
before myfunc() called.
 myfunc(3,4) called.
  after myfunc() called. result:
第四步 ：让装饰器带参数
# -*- coding:gbk -*-
'''示例7: 在示例4的基础上，让装饰器带参数，
和上一示例相比在外层多了一层包装。
装饰函数名实际上应更有意义些'''
def deco(arg):
    def _deco(func):
        def __deco():
            print("before %s called [%s]." % (func.__name__, arg))
            func()
            print("  after %s called [%s]." % (func.__name__, arg))
        return __deco
    return _deco

@deco("mymodule")
def myfunc():
    print(" myfunc() called.")
@deco("module2")
def myfunc2():
    print(" myfunc2() called.")
myfunc()
myfunc2()
输出：
before myfunc called [mymodule].
 myfunc() called.
  after myfunc called [mymodule].
before myfunc2 called [module2].
 myfunc2() called.
  after myfunc2 called [module2].
这种带参数的装饰器怎么解释呢。其实是一样的，还是我们的替换操作 
@deco(“mymodule”)替换为myfunc = deco(“mymodule”)(myfunc ) 
注意啊，这里deco后面跟了两个括号。 
有同学要问了，这是什么意思？ 
其实很简单，先执行deco(“mymodule”)，返回结果为_deco 
再执行_deco(myfunc)，得到的返回结果为__deco 
所以myfunc = __deco
破案！

偏函数：
functools.partial就是帮助我们创建一个偏函数的，不需要我们自己定义int2()，可以直接使用下面的代码创建一个新的函数int2：

>>> import functools
>>> int2 = functools.partial(int, base=2)
>>> int2('1000000')
64
>>> int2('1010101')
85
上面等价于：
def int2(x, base=2):
    return int(x, base)
这样，我们转换二进制就非常方便了：

>>> int2('1000000')
64
>>> int2('1010101')
85

作用域
有的函数和变量我们希望仅仅在模块内部使用。在Python中，是通过_前缀来实现的。
类似_xxx和__xxx这样的函数或变量就是非公开的（private）


如果要让内部属性不被外部访问，可以把属性的名称前加上两个下划线__，在Python中，实例的变量名如果以__开头，就变成了一个私有变量（private），只有内部可以访问，外部不能访问。需要注意的是，在Python中，变量名类似__xxx__的，也就是以双下划线开头，并且以双下划线结尾的，是特殊变量，特殊变量是可以直接访问的，不是private变量，所以，不能用__name__、__score__这样的变量名。不能直接访问__name是因为Python解释器对外把__name变量改成了_Student__name，所以，仍然可以通过_Student__name来访问__name变量：但是强烈建议你不要这么干，因为不同版本的Python解释器可能会把__name改成不同的变量名。
当子类和父类都存在相同的run()方法时，我们说，子类的run()覆盖了父类的run()，在代码运行的时候，总是会调用子类的run()。这样，我们就获得了继承的另一个好处：多态。
多态的好处就是，当我们需要传入Dog、Cat、Tortoise……时，我们只需要接收Animal类型就可以了，因为Dog、Cat、Tortoise……都是Animal类型，然后，按照Animal类型进行操作即可。由于Animal类型有run()方法，因此，传入的任意类型，只要是Animal类或者子类，就会自动调用实际类型的run()方法，这就是多态的意思：
对于静态语言（例如Java）来说，如果需要传入Animal类型，则传入的对象必须是Animal类型或者它的子类，否则，将无法调用run()方法。
对于Python这样的动态语言来说，则不一定需要传入Animal类型。我们只需要保证传入的对象有一个run()方法就可以了：
class Timer(object):
    def run(self):
        print('Start...')
这就是动态语言的“鸭子类型”，它并不要求严格的继承体系，一个对象只要“看起来像鸭子，走起路来像鸭子”，那它就可以被看做是鸭子。
Python的“file-like object“就是一种鸭子类型。对真正的文件对象，它有一个read()方法，返回其内容。但是，许多对象，只要有read()方法，都被视为“file-like object“。许多函数接收的参数就是“file-like object“，你不一定要传入真正的文件对象，完全可以传入任何实现了read()方法的对象。
当我们拿到一个对象的引用时，如何知道这个对象是什么类型、有哪些方法呢？
1、	type()但是type()函数返回的是什么类型呢？它返回对应的Class类型。
如果要判断一个对象是否是函数怎么办？可以使用types模块中定义的常量：
>>> import types
>>> def fn():
...     pass
...
>>> type(fn)==types.FunctionType
True
>>> type(abs)==types.BuiltinFunctionType
True
>>> type(lambda x: x)==types.LambdaType
True
>>> type((x for x in range(10)))==types.GeneratorType
True
对于class的继承关系来说，使用type()就很不方便。我们要判断class的类型，可以使用isinstance()函数。
object -> Animal -> Dog -> Husky
那么，isinstance()就可以告诉我们，一个对象是否是某种类型。先创建3种类型的对象：
>>> a = Animal()
>>> d = Dog()
>>> h = Husky()
然后，判断：
>>> isinstance(h, Husky)
True
如果要获得一个对象的所有属性和方法，可以使用dir()函数，它返回一个包含字符串的list，比如，获得一个str对象的所有属性和方法：
>>> dir('ABC')
['__add__', '__class__',..., '__subclasshook__', 'capitalize', 'casefold',..., 'zfill']
看到评论中有同学在问，这一章所讲的内容一般在什么时候会用到呢，我就翻了下，然后记录下来，给后面的同学做个参考。
# 首先你有一个command.py文件，内容如下，这里我们假若它后面还有100个方法

class MyObject(object):
    def __init__(self):
        self.x = 9
    def add(self):
        return self.x + self.x

    def pow(self):
        return self.x * self.x

    def sub(self):
        return self.x - self.x

    def div(self):
        return self.x / self.x
# 然后我们有一个入口文件 exec.py，要根据用户的输入来执行后端的操作
from command import MyObject
computer=MyObject()

def run():
    inp = input('method>')

    if inp == 'add':
        computer.add()
    elif inp == 'sub':
        computer.sub()
    elif inp == 'div':
        computer.div()
    elif inp == 'pow':
        computer.pow()
    else:
        print('404')
上面使用了if来进行判断，那么假若我的command里面真的有100个方法，那我总不可能写100次判断吧，所以这里我们就会用到python的反射特性，看下面的代码
from command import MyObject

computer=MyObject()
def run(x):
    inp = input('method>')
    # 判断是否有这个属性
    if hasattr(computer,inp):
    # 有就获取然后赋值给新的变量
        func = getattr(computer,inp)
        print(func())
    else:
    # 没有我们来set一个
        setattr(computer,inp,lambda x:x+1)
        func = getattr(computer,inp)
        print(func(x))

if __name__ == '__main__':
    run(10)
使用__slots__
但是，如果我们想要限制实例的属性怎么办？比如，只允许对Student实例添加name和age属性。
为了达到限制的目的，Python允许在定义class的时候，定义一个特殊的__slots__变量，来限制该class实例能添加的属性：
class Student(object):
    __slots__ = ('name', 'age') # 用tuple定义允许绑定的属性名称
然后，我们试试：
>>> s = Student() # 创建新的实例
>>> s.name = 'Michael' # 绑定属性'name'
>>> s.age = 25 # 绑定属性'age'
>>> s.score = 99 # 绑定属性'score'
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
AttributeError: 'Student' object has no attribute 'score'
使用__slots__要注意，__slots__定义的属性仅对当前类实例起作用，对继承的子类是不起作用的：

@property

@property 的用途是什么呢？

下面一步一步地介绍。

定义类Student，拥有变量名name和score
[java] view plain copy
class Student(object):  
    def __init__(self,name,score):  
        self.name = name  
        self.score = score  
[java] view plain copy
class Student(object):  
    def __init__(self,name,score):  
        self.name = name  
        self.score = score  
这样，我们可以在类外修改Student的实例的成员变量:
[java] view plain copy
s1 = Student()  
s1.name = ”Lily”  
s1.score = 9999 # 这里的定义是不合理的  

但是，上述这样定义score是不会进行参数检查的，也就意味着我们不能执行必要的参数以及错误处理。

我们可以定义相应的set和get成员函数来访问成员变量score，并且进行参数检查。如下所示：

[java] view plain copy
class Student(object):  
    def __init__(self,name,score):  
        self.name = name  
        self.score = score  
    def get_score(self):  
        return self.score  
    def set_score(self,score):  
        if not isinstance(score, int):  
            raise ValueError(”invalid score!!!”)  
        if score < 0 or score > 100:  
            raise ValueError(”score must be between [0,100]!!!”)  
        self._score = score  
上述代码定义了score成员的set和get函数。（可能实际应用时，修改分数比较常见）

现在，我们改变参数的代码是这样的：

[java] view plain copy
s1 = Student()  
s1.set_score(9999) #这里会抛出异常  
上述的第二种方式实现了set函数的参数检查，但是修改score的代码从简单的 s1.score = 90 变成了 s1.set_score(90) .我们怎么样才能做到既检验输入的参数又使得修改score的代码不变呢？

@Property便是这个作用。

下面，我们讨论Python的高级特性 @Property。简单的说@Properyty就是将成员函数的调用变成属性赋值。

于是有了下面的代码：

[java] view plain copy
class Student(object):  
    def __init__(self,name,score):  
        self._name = name  
        self._score = score  
    @property  
    def score(self):   
        return self._score  
    @score.setter   
    def score(self,score):    
        if not isinstance(score,int):  
            raise ValueError(”invalid score!!!”)  
        if score < 0 or score > 100:  
            raise ValueError(”score must be between [0,100]!!!”)   
        self._score = score  
    @property  
    def name(self):   
        return self._name  
  
s1 = Student(”Lily”, 90)  
s1.name = ”Luly”  
s1.score = 100  
关于上述代码的说明：

可能你已经发现了，我的成员变量改成了_name 与 _score，这里首先是为了增加可读性，这两个变量是私有的。其次的原因见下面的误区分析。
上述代码中的 s1.name = “Luly” 行会出现编译错误 AttributeError: can’t set attribute ,也就是说这里不能直接这样改变，这是为什么呢？可以看到，在代码中，我并没有提供名称为name的set函数， 这里值得注意的是，s1._name = “Lucy” 是可以运行通过的。但是我们之前说过了，假设用户足够自觉，不会去操作 _xxx 或者 __xxx这样的变量名。
按照上述代码的初衷，也就是说name是类的只读的属性。score是可修改的。
关于@property 修饰的函数 score 就是个简单的get函数，该函数不需要任何参数（self不需要传入值），因此我们可以这样来调用这个函数 ,即 s1.score 即可。（这就是Property的用处，将函数调用转化为属性访问），相当于给score加了一层包裹。
关于@score.setter 便是针对与 score函数包裹的成员变量的的set函数。当我们需要修改_score的值时，使用score函数，但是就像score是类的成员属性一样使用，例如上面的： s1.score = 100，实际上等价于 s1.score(100).
注意，这里的函数名不一定要是score，可以是任何的字符串，这里只是为了方面说score函数是_score的包裹，例如下面的代码：我们将score改成了AA，但是这样在:
[python] view plain copy
 在CODE上查看代码片派生到我的代码片
class Student(object):  
  
    def __init__(self,name,score):  
        self._name = name  
        self._score = score  
 
    @property  
    def AA(self):  
        return self._score  
    @AA.setter  
    def AA(self,score):  
        if not isinstance(score,int):  
            raise ValueError(“invalid score!!!”)  
        if score < 0 or score > 100:  
            raise ValueError(“score must be between [0,100]!!!”)  
        self._score = score  
    @property  
    def name(self):  
        return self._name  
            
s1 = Student(”Lily”, 90)  
s1.name = ”Luly”  
s1.AA = 100 # 这里相当于是 s1.AA(100)  
好了，关于@Property的概念与用法就讲完了。本质上是定义了新的函数，该函数们执行set与get的功能，并且有@Property的包裹。并且将这些定
义的函数当作属性一样来赋值。

可能存在的陷阱：

下面的代码是个大的陷阱，因为现在的函数已经不再是单纯的函数，而是可以直接用 = 来调用，例如上面的 score函数 的调用竟然是 s1.score = 100 .这样就
会出现下面的问题：

[java] view plain copy
class Student(object):   
    def __init__(self,name,score):         
        self.name = name      
        self.score = score     
    @property     
    def score(self):  
        return self.score   
    @score.setter   
    def score(self,score):     
        if not isinstance(score,int):   
            raise ValueError(”invalid score!!!”)    
        if score < 0 or score > 100:       
            raise ValueError(”score must be between [0,100]!!!”)      
        self.score = score   
    @property   
    def name(self):   
        return self.name   
    def func(self):      
        self.score = score   
  
s1 = Student(”Lily”, 90)  
s1.func()  
上面的代码有两个很大的错误，

你会发现，你无法定义Student的任何实例，为什么呢？ 首先@property把score和name两个成员函数可以当作成员变量来访问，那么在定义实例时，调用init函
数的时候，self.name = name,这一句，Python会将左端的self.name当作函数调用，然而我们并未给name变量 定义set函数，于是错误信息为：
AttributeError: can’t set attribute.
这里其实是一个很好的代码习惯，那就是尽量不要让函数名与变量名同名，便可以避免这些错误。所以，比如说，这里的变量名self.score改为：self._score就可以避免递归错误。

python 多重继承之拓扑排序
一、什么是拓扑排序

在图论中，拓扑排序(Topological Sorting) 是一个 有向无环图(DAG,Directed Acyclic Graph) 的所有顶点的线性序列。且该序列必须满足下面两个条件：

每个顶点出现且只出现一次。
若存在一条从顶点A到顶点B的路径，那么在序列中顶点A出现在顶点B的前面。
例如，下面这个图：
![image](https://github.com/shaocj/python_mine/blob/master/image/0.png)
它是一个DAG图，那么如何写出它的拓扑顺序呢？这里说一种比较常用的方法：

从DAG途中选择一个没有前驱(即入度为0)的顶点并输出
从图中删除该顶点和所有以它为起点的有向边。
重复1和2直到当前DAG图为空或当前途中不存在无前驱的顶点为止。后一种情况说明有向图中必然存在环。
![image](https://github.com/shaocj/python_mine/blob/master/image/1.png)
于是，得到拓扑排序后的结果是{1,2,4,3,5}

下面，我们看看拓扑排序在python多重继承中的例子

二、python 多重继承

 #!/usr/bin/env python3
# -*- coding: utf-8 -*-
class A(object):
    def foo(self):
        print('A foo')
    def bar(self):
        print('A bar')

class B(object):
    def foo(self):
        print('B foo')
    def bar(self):
        print('B bar')

class C1(A,B):
    pass

class C2(A,B):
    def bar(self):
        print('C2-bar')

class D(C1,C2):
    pass

if __name__ == '__main__':
    print(D.__mro__)
    d=D()
    d.foo()
    d.bar()
首先，我们根据上面的继承关系构成一张图，如下
![iamge](https://github.com/shaocj/python_mine/blob/master/image/2.png)
找到入度为0的点，只有一个D，把D拿出来，把D相关的边剪掉
现在有两个入度为0的点(C1,C2)，取最左原则，拿C1，剪掉C1相关的边，这时候的排序是{D,C1}
现在我们看，入度为0的点(C2),拿C2,剪掉C2相关的边，这时候排序是{D,C1,C2}
接着看，入度为0的点(A,B),取最左原则，拿A，剪掉A相关的边，这时候的排序是{D,C1,C2,A}
继续，入度哦为0的点只有B，拿B，剪掉B相关的边，最后只剩下object
所以最后的排序是{D,C1,C2,A,B,object}
我们执行上面的代码，发现print(D.__mro__)的结果也正是这样，而这也就是多重继承所使用的C3算法啦

为了进一步熟悉这个拓扑排序的方法，我们再来一张图，试试看排序结果是怎样的，它继承的内容是否如你所想
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
class A(object):
    def foo(self):
        print('A foo')
    def bar(self):
        print('A bar')

class B(object):
    def foo(self):
        print('B foo')
    def bar(self):
        print('B bar')

class C1(A):
    pass

class C2(B):
    def bar(self):
        print('C2-bar')

class D(C1,C2):
    pass

if __name__ == '__main__':
    print(D.__mro__)
    d=D()
    d.foo()
    d.bar()
还是先根据继承关系构一个继承图
![image](https://github.com/shaocj/python_mine/blob/master/image/3.png)
找到入度为0的顶点，只有一个D，拿D，剪掉D相关的边
得到两个入度为0的顶点(C1,C2),根据最左原则，拿C1，剪掉C1相关的边，这时候序列为{D,C1}
接着看，入度为0的顶点有两个(A,C1),根据最左原则，拿A，剪掉A相关的边，这时候序列为{D,C1,A}
接着看，入度为0的顶点为C2,拿C2，剪掉C2相关的边，这时候序列为{D,C1,A,C2}
继续，入度为0的顶点为B，拿B，剪掉B相关的边，最后还有一个object
所以最后的序列为{D,C1,A,C2,B,object}
最后，我们执行上面的代码，发现print(D.__mro__)的结果正如上面所计算的结果

最后的最后，python继承顺序遵循C3算法，只要在一个地方找到了所需的内容，就不再继续查找

定制类
_str__
我们先定义一个Student类，打印一个实例：
>>> class Student(object):
...     def __init__(self, name):
...         self.name = name
...
>>> print(Student('Michael'))
<__main__.Student object at 0x109afb190>
打印出一堆<__main__.Student object at 0x109afb190>，不好看。
怎么才能打印得好看呢？只需要定义好__str__()方法，返回一个好看的字符串就可以了：
>>> class Student(object):
...     def __init__(self, name):
...         self.name = name
...     def __str__(self):
...         return 'Student object (name: %s)' % self.name
...
>>> print(Student('Michael'))
Student object (name: Michael)
这样打印出来的实例，不但好看，而且容易看出实例内部重要的数据。
但是细心的朋友会发现直接敲变量不用print，打印出来的实例还是不好看：
>>> s = Student('Michael')
>>> s
<__main__.Student object at 0x109afb310>
这是因为直接显示变量调用的不是__str__()，而是__repr__()，两者的区别是__str__()返回用户看到的字符串，而__repr__()返回程序开发者看到的字符串，也就是说，__repr__()是为调试服务的。
解决办法是再定义一个__repr__()。但是通常__str__()和__repr__()代码都是一样的，所以，有个偷懒的写法：
class Student(object):
    def __init__(self, name):
        self.name = name
    def __str__(self):
        return 'Student object (name=%s)' % self.name
    __repr__ = __str__
__iter__
如果一个类想被用于for ... in循环，类似list或tuple那样，就必须实现一个__iter__()方法，该方法返回一个迭代对象，然后，Python的for循环就会不断调用该迭代对象的__next__()方法拿到循环的下一个值，直到遇到StopIteration错误时退出循环。
我们以斐波那契数列为例，写一个Fib类，可以作用于for循环：
class Fib(object):
    def __init__(self):
        self.a, self.b = 0, 1 # 初始化两个计数器a，b

    def __iter__(self):
        return self # 实例本身就是迭代对象，故返回自己

    def __next__(self):
        self.a, self.b = self.b, self.a + self.b # 计算下一个值
        if self.a > 100000: # 退出循环的条件
            raise StopIteration()
        return self.a # 返回下一个值
现在，试试把Fib实例作用于for循环：
>>> for n in Fib():
...     print(n)
...
1
1
2
3
5
...
46368
75025
__getitem__
Fib实例虽然能作用于for循环，看起来和list有点像，但是，把它当成list来使用还是不行，比如，取第5个元素：
>>> Fib()[5]
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: 'Fib' object does not support indexing
要表现得像list那样按照下标取出元素，需要实现__getitem__()方法：
class Fib(object):
    def __getitem__(self, n):
        a, b = 1, 1
        for x in range(n):
            a, b = b, a + b
        return a
现在，就可以按下标访问数列的任意一项了：
>>> f = Fib()
>>> f[0]
1
但是list有个神奇的切片方法：
>>> list(range(100))[5:10]
[5, 6, 7, 8, 9]
对于Fib却报错。原因是__getitem__()传入的参数可能是一个int，也可能是一个切片对象slice，所以要做判断：
class Fib(object):
    def __getitem__(self, n):
        if isinstance(n, int): # n是索引
            a, b = 1, 1
            for x in range(n):
                a, b = b, a + b
            return a
        if isinstance(n, slice): # n是切片
            start = n.start
            stop = n.stop
            if start is None:
                start = 0
            a, b = 1, 1
            L = []
            for x in range(stop):
                if x >= start:
                    L.append(a)
                a, b = b, a + b
            return L


__getattr__
正常情况下，当我们调用类的方法或属性时，如果不存在，就会报错。比如定义Student类：
class Student(object):

    def __init__(self):
        self.name = 'Michael'
调用name属性，没问题，但是，调用不存在的score属性，就有问题了：
>>> s = Student()
>>> print(s.name)
Michael
>>> print(s.score)
Traceback (most recent call last):
  ...
AttributeError: 'Student' object has no attribute 'score'
错误信息很清楚地告诉我们，没有找到score这个attribute。
要避免这个错误，除了可以加上一个score属性外，Python还有另一个机制，那就是写一个__getattr__()方法，动态返回一个属性。修改如下：
class Student(object):

    def __init__(self):
        self.name = 'Michael'

    def __getattr__(self, attr):
        if attr=='score':
            return 99
当调用不存在的属性时，比如score，Python解释器会试图调用__getattr__(self, 'score')来尝试获得属性，这样，我们就有机会返回score的值：
>>> s = Student()
>>> s.name
'Michael'
>>> s.score
99
返回函数也是完全可以的：
class Student(object):

    def __getattr__(self, attr):
        if attr=='age':
            return lambda: 25
只是调用方式要变为：
>>> s.age()
25
注意，只有在没有找到属性的情况下，才调用__getattr__，已有的属性，比如name，不会在__getattr__中查找。
此外，注意到任意调用如s.abc都会返回None，这是因为我们定义的__getattr__默认返回就是None。要让class只响应特定的几个属性，我们就要按照约定，抛出AttributeError的错误：
class Student(object):

    def __getattr__(self, attr):
        if attr=='age':
            return lambda: 25
        raise AttributeError('\'Student\' object has no attribute \'%s\'' % attr)
这实际上可以把一个类的所有属性和方法调用全部动态化处理了，不需要任何特殊手段。
__call__
一个对象实例可以有自己的属性和方法，当我们调用实例方法时，我们用instance.method()来调用。能不能直接在实例本身上调用呢？在Python中，答案是肯定的。
任何类，只需要定义一个__call__()方法，就可以直接对实例进行调用。请看示例：
class Student(object):
    def __init__(self, name):
        self.name = name

    def __call__(self):
        print('My name is %s.' % self.name)
调用方式如下：
>>> s = Student('Michael')
>>> s() # self参数不要传入
My name is Michael.
__call__()还可以定义参数。对实例进行直接调用就好比对一个函数进行调用一样，所以你完全可以把对象看成函数，把函数看成对象，因为这两者之间本来就没啥根本的区别。
如果你把对象看成函数，那么函数本身其实也可以在运行期动态创建出来，因为类的实例都是运行期创建出来的，这么一来，我们就模糊了对象和函数的界限。
那么，怎么判断一个变量是对象还是函数呢？其实，更多的时候，我们需要判断一个对象是否能被调用，能被调用的对象就是一个Callable对象，比如函数和我们上面定义的带有__call__()的类实例：
>>> callable(Student())
True
>>> callable(max)
True
>>> callable([1, 2, 3])
False
>>> callable(None)
False
>>> callable('str')
False
通过callable()函数，我们就可以判断一个对象是否是“可调用”对象。
枚举类：

Python提供了Enum类来实现这个功能：
from enum import Enum

Month = Enum('Month', ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'))
枚举的定义
首先，定义枚举要导入enum模块。
枚举定义用class关键字，继承Enum类。
注意:
定义枚举时，成员名称不允许重复　
默认情况下，不同的成员值允许相同。但是两个相同值的成员，第二个成员的名称被视作第一个成员的别名　
如果枚举中存在相同值的成员，在通过值获取枚举成员时，只能获取到第一个成员
如果要限制定义枚举时，不能定义相同值的成员。可以使用装饰器@unique【要导入unique模块】
?
1
2	for name, member in Month.__members__.items():
  print(name, '=>', member, ',', member.value)
如果需要更精确地控制枚举类型，可以从Enum派生出自定义类：
from enum import Enum, unique

@unique
class Weekday(Enum):
    Sun = 0 # Sun的value被设定为0
    Mon = 1
    Tue = 2
    Wed = 3
    Thu = 4
    Fri = 5
    Sat = 6
@unique装饰器可以帮助我们检查保证没有重复值。
访问这些枚举类型可以有若干种方法：
>>> day1 = Weekday.Mon
>>> print(day1)
Weekday.Mon
>>> print(Weekday.Tue)
Weekday.Tue
>>> print(Weekday['Tue'])
Weekday.Tue
>>> print(Weekday.Tue.value)
2
>>> print(day1 == Weekday.Mon)
True
>>> print(Weekday(1))
Weekday.Mon
for name, member in Weekday.__members__.items():
...     print(name, '=>', member)
...
Sun => Weekday.Sun
Mon => Weekday.Mon
Tue => Weekday.Tue
Wed => Weekday.Wed
Thu => Weekday.Thu
Fri => Weekday.Fri
Sat => Weekday.Sat
可见，既可以用成员名称引用枚举常量，又可以直接根据value的值获得枚举常量。
第一种：
from enum import Enum

Gender=Enum('Gender',('Male','Female'))
class Student(object):
    def __init__(self, name, gender):
        self.name = name
        self.gender = gender
第二种：
#枚举类
from enum import Enum,unique

@unique
class Gender(Enum):
    Male = 0
    Female = 1
class Student(object):
    def __init__(self, name, gender):
        self.name = name
        self.gender = gender

元类：
type()
动态语言和静态语言最大的不同，就是函数和类的定义，不是编译时定义的，而是运行时动态创建的。
比方说我们要定义一个Hello的class，就写一个hello.py模块：
class Hello(object):
    def hello(self, name='world'):
        print('Hello, %s.' % name)
当Python解释器载入hello模块时，就会依次执行该模块的所有语句，执行结果就是动态创建出一个Hello的class对象，测试如下：
>>> from hello import Hello
>>> h = Hello()
>>> h.hello()
Hello, world.
>>> print(type(Hello))
<class 'type'>
>>> print(type(h))
<class 'hello.Hello'>
type()函数可以查看一个类型或变量的类型，Hello是一个class，它的类型就是type，而h是一个实例，它的类型就是class Hello。
我们说class的定义是运行时动态创建的，而创建class的方法就是使用type()函数。
type()函数既可以返回一个对象的类型，又可以创建出新的类型，比如，我们可以通过type()函数创建出Hello类，而无需通过class Hello(object)...的定义：
>>> def fn(self, name='world'): # 先定义函数
...     print('Hello, %s.' % name)
...
>>> Hello = type('Hello', (object,), dict(hello=fn)) # 创建Hello class
>>> h = Hello()
>>> h.hello()
Hello, world.
>>> print(type(Hello))
<class 'type'>
>>> print(type(h))
<class '__main__.Hello'>
要创建一个class对象，type()函数依次传入3个参数：
1.	class的名称；
2.	继承的父类集合，注意Python支持多重继承，如果只有一个父类，别忘了tuple的单元素写法；
3.	class的方法名称与函数绑定，这里我们把函数fn绑定到方法名hello上。
4.	记录错误
5.	如果不捕获错误，自然可以让Python解释器来打印出错误堆栈，但程序也被结束了。既然我们能捕获错误，就可以把错误堆栈打印出来，然后分析错误原因，同时，让程序继续执行下去。
6.	Python内置的logging模块可以非常容易地记录错误信息：
7.	# err_logging.py
8.	
9.	import logging
10.	
11.	def foo(s):
12.	    return 10 / int(s)
13.	
14.	def bar(s):
15.	    return foo(s) * 2
16.	
17.	def main():
18.	    try:
19.	        bar('0')
20.	    except Exception as e:
21.	        logging.exception(e)
22.	
23.	main()
24.	print('END')
25.	同样是出错，但程序打印完错误信息后会继续执行，并正常退出：
26.	$ python3 err_logging.py
27.	ERROR:root:division by zero
28.	Traceback (most recent call last):
29.	  File "err_logging.py", line 13, in main
30.	    bar('0')
31.	  File "err_logging.py", line 9, in bar
32.	    return foo(s) * 2
33.	  File "err_logging.py", line 6, in foo
34.	    return 10 / int(s)
35.	ZeroDivisionError: division by zero
36.	END
37.	通过配置，logging还可以把错误记录到日志文件里，方便事后排查。
调试：
断言
凡是用print()来辅助查看的地方，都可以用断言（assert）来替代：
def foo(s):
    n = int(s)
    assert n != 0, 'n is zero!'
    return 10 / n

def main():
    foo('0')
assert的意思是，表达式n != 0应该是True，否则，根据程序运行的逻辑，后面的代码肯定会出错。
如果断言失败，assert语句本身就会抛出AssertionError：
$ python err.py
Traceback (most recent call last):
  ...
AssertionError: n is zero!
程序中如果到处充斥着assert，和print()相比也好不到哪去。不过，启动Python解释器时可以用-O参数来关闭assert：
$ python -O err.py
Traceback (most recent call last):
  ...
ZeroDivisionError: division by zero
关闭后，你可以把所有的assert语句当成pass来看。
logging
把print()替换为logging是第3种方式，和assert比，logging不会抛出错误，而且可以输出到文件：
import logging

s = '0'
n = int(s)
logging.info('n = %d' % n)
print(10 / n)
logging.info()就可以输出一段文本。运行，发现除了ZeroDivisionError，没有任何信息。怎么回事？
别急，在import logging之后添加一行配置再试试：
import logging
logging.basicConfig(level=logging.INFO)
看到输出了：
$ python err.py
INFO:root:n = 0
Traceback (most recent call last):
  File "err.py", line 8, in <module>
    print(10 / n)
ZeroDivisionError: division by zero
这就是logging的好处，它允许你指定记录信息的级别，有debug，info，warning，error等几个级别，当我们指定level=INFO时，logging.debug就不起作用了。同理，指定level=WARNING后，debug和info就不起作用了。这样一来，你可以放心地输出不同级别的信息，也不用删除，最后统一控制输出哪个级别的信息。
logging的另一个好处是通过简单的配置，一条语句可以同时输出到不同的地方，比如console和文件。
调试
阅读: 117163
________________________________________
程序能一次写完并正常运行的概率很小，基本不超过1%。总会有各种各样的bug需要修正。有的bug很简单，看看错误信息就知道，有的bug很复杂，我们需要知道出错时，哪些变量的值是正确的，哪些变量的值是错误的，因此，需要一整套调试程序的手段来修复bug。
第一种方法简单直接粗暴有效，就是用print()把可能有问题的变量打印出来看看：
def foo(s):
    n = int(s)
    print('>>> n = %d' % n)
    return 10 / n

def main():
    foo('0')

main()
执行后在输出中查找打印的变量值：
$ python err.py
>>> n = 0
Traceback (most recent call last):
  ...
ZeroDivisionError: integer division or modulo by zero
用print()最大的坏处是将来还得删掉它，想想程序里到处都是print()，运行结果也会包含很多垃圾信息。所以，我们又有第二种方法。
断言
凡是用print()来辅助查看的地方，都可以用断言（assert）来替代：
def foo(s):
    n = int(s)
    assert n != 0, 'n is zero!'
    return 10 / n

def main():
    foo('0')
assert的意思是，表达式n != 0应该是True，否则，根据程序运行的逻辑，后面的代码肯定会出错。
如果断言失败，assert语句本身就会抛出AssertionError：
$ python err.py
Traceback (most recent call last):
  ...
AssertionError: n is zero!
程序中如果到处充斥着assert，和print()相比也好不到哪去。不过，启动Python解释器时可以用-O参数来关闭assert：
$ python -O err.py
Traceback (most recent call last):
  ...
ZeroDivisionError: division by zero
关闭后，你可以把所有的assert语句当成pass来看。
logging
把print()替换为logging是第3种方式，和assert比，logging不会抛出错误，而且可以输出到文件：
import logging

s = '0'
n = int(s)
logging.info('n = %d' % n)
print(10 / n)
logging.info()就可以输出一段文本。运行，发现除了ZeroDivisionError，没有任何信息。怎么回事？
别急，在import logging之后添加一行配置再试试：
import logging
logging.basicConfig(level=logging.INFO)
看到输出了：
$ python err.py
INFO:root:n = 0
Traceback (most recent call last):
  File "err.py", line 8, in <module>
    print(10 / n)
ZeroDivisionError: division by zero
这就是logging的好处，它允许你指定记录信息的级别，有debug，info，warning，error等几个级别，当我们指定level=INFO时，logging.debug就不起作用了。同理，指定level=WARNING后，debug和info就不起作用了。这样一来，你可以放心地输出不同级别的信息，也不用删除，最后统一控制输出哪个级别的信息。
logging的另一个好处是通过简单的配置，一条语句可以同时输出到不同的地方，比如console和文件。
pdb
第4种方式是启动Python的调试器pdb，让程序以单步方式运行，可以随时查看运行状态。我们先准备好程序：
# err.py
s = '0'
n = int(s)
print(10 / n)
然后启动：
$ python -m pdb err.py
> /Users/michael/Github/learn-python3/samples/debug/err.py(2)<module>()
-> s = '0'
以参数-m pdb启动后，pdb定位到下一步要执行的代码-> s = '0'。输入命令l来查看代码：
(Pdb) l
  1     # err.py
  2  -> s = '0'
  3     n = int(s)
  4     print(10 / n)
输入命令n可以单步执行代码：
(Pdb) n
> /Users/michael/Github/learn-python3/samples/debug/err.py(3)<module>()
-> n = int(s)
(Pdb) n
> /Users/michael/Github/learn-python3/samples/debug/err.py(4)<module>()
-> print(10 / n)
任何时候都可以输入命令p 变量名来查看变量：
(Pdb) p s
'0'
(Pdb) p n
0
输入命令q结束调试，退出程序：
(Pdb) q
这种通过pdb在命令行调试的方法理论上是万能的，但实在是太麻烦了，如果有一千行代码，要运行到第999行得敲多少命令啊。还好，我们还有另一种调试方法。
pdb.set_trace()
这个方法也是用pdb，但是不需要单步执行，我们只需要import pdb，然后，在可能出错的地方放一个pdb.set_trace()，就可以设置一个断点：
# err.py
import pdb

s = '0'
n = int(s)
pdb.set_trace() # 运行到这里会自动暂停
print(10 / n)
运行代码，程序会自动在pdb.set_trace()暂停并进入pdb调试环境，可以用命令p查看变量，或者用命令c继续运行：
$ python err.py 
> /Users/michael/Github/learn-python3/samples/debug/err.py(7)<module>()
-> print(10 / n)
(Pdb) p n
0
(Pdb) c
Traceback (most recent call last):
  File "err.py", line 7, in <module>
    print(10 / n)
ZeroDivisionError: division by zero
IO读写：
由于文件读写时都有可能产生IOError，一旦出错，后面的f.close()就不会调用。所以，为了保证无论是否出错都能正确地关闭文件，我们可以使用try ... finally来实现：
try:
    f = open('/path/to/file', 'r')
    print(f.read())
finally:
    if f:
        f.close()
但是每次都这么写实在太繁琐，所以，Python引入了with语句来自动帮我们调用close()方法：
with open('/path/to/file', 'r') as f:
    print(f.read())
调用readline()可以每次读取一行内容，调用readlines()一次读取所有内容并按行返回list
# StringIO和BytesIO

# stringIO 比如说，这时候，你需要对获取到的数据进行操作，但是你并不想把数据写到本地硬盘上，这时候你就可以用stringIO
from io import StringIO
from io import BytesIO
def outputstring():
    return 'string \nfrom \noutputstring \nfunction'

s = outputstring()

# 将函数返回的数据在内存中读
sio = StringIO(s)
# 可以用StringIO本身的方法
print(sio.getvalue())
# 也可以用file-like object的方法
s = sio.readlines()
for i in s:
    print(i.strip())


# 将函数返回的数据在内存中写
sio = StringIO()
sio.write(s)
# 可以用StringIO本身的方法查看
s=sio.getvalue()
print(s)

# 如果你用file-like object的方法查看的时候，你会发现数据为空

sio = StringIO()
sio.write(s)
for i in sio.readlines():
    print(i.strip())

# 这时候我们需要修改下文件的指针位置
# 我们发现可以打印出内容了
sio = StringIO()
sio.write(s)
sio.seek(0,0)
print(sio.tell())
for i in sio.readlines():
    print(i.strip())

# 这就涉及到了两个方法seek 和 tell
# tell 方法获取当前文件读取指针的位置
# seek 方法，用于移动文件读写指针到指定位置,有两个参数，第一个offset: 偏移量，需要向前或向后的字节数，正为向后，负为向前；第二个whence: 可选值，默认为0，表示文件开头，1表示相对于当前的位置，2表示文件末尾
# 用seek方法时，需注意，如果你打开的文件没有用'b'的方式打开，则offset无法使用负值哦



# stringIO 只能操作str，如果要操作二进制数据，就需要用到BytesIO
# 上面的sio无法用seek从当前位置向前移动，这时候，我们用'b'的方式写入数据，就可以向前移动了
bio = BytesIO()
bio.write(s.encode('utf-8'))
print(bio.getvalue())
bio.seek(-36,1)
print(bio.tell())
for i in bio.readlines():
    print(i.strip())

环境变量
在操作系统中定义的环境变量，全部保存在os.environ这个变量中，可以直接查看：
>>> os.environ
操作文件和目录
操作文件和目录的函数一部分放在os模块中，一部分放在os.path模块中，这一点要注意一下。查看、创建和删除目录可以这么调用：
# 查看当前目录的绝对路径:
>>> os.path.abspath('.')
'/Users/michael'
# 在某个目录下创建一个新目录，首先把新目录的完整路径表示出来:
>>> os.path.join('/Users/michael', 'testdir')
'/Users/michael/testdir'
# 然后创建一个目录:
>>> os.mkdir('/Users/michael/testdir')
# 删掉一个目录:
>>> os.rmdir('/Users/michael/testdir')
操作文件和目录
操作文件和目录的函数一部分放在os模块中，一部分放在os.path模块中，这一点要注意一下。查看、创建和删除目录可以这么调用：
# 查看当前目录的绝对路径:
>>> os.path.abspath('.')
'/Users/michael'
# 在某个目录下创建一个新目录，首先把新目录的完整路径表示出来:
>>> os.path.join('/Users/michael', 'testdir')
'/Users/michael/testdir'
# 然后创建一个目录:
>>> os.mkdir('/Users/michael/testdir')
# 删掉一个目录:
>>> os.rmdir('/Users/michael/testdir')
把两个路径合成一个时，不要直接拼字符串，而要通过os.path.join()函数，这样可以正确处理不同操作系统的路径分隔符。在Linux/Unix/Mac下，os.path.join()返回这样的字符串：
part-1/part-2
同样的道理，要拆分路径时，也不要直接去拆字符串，而要通过os.path.split()函数，这样可以把一个路径拆分为两部分，后一部分总是最后级别的目录或文件名：
>>> os.path.split('/Users/michael/testdir/file.txt')
('/Users/michael/testdir', 'file.txt')
os.path.splitext()可以直接让你得到文件扩展名，很多时候非常方便：
>>> os.path.splitext('/path/to/file.txt')
('/path/to/file', '.txt')
这些合并、拆分路径的函数并不要求目录和文件要真实存在，它们只对字符串进行操作。

multiprocessing模块就是跨平台版本的多进程模块。
multiprocessing模块提供了一个Process类来代表一个进程对象，下面的例子演示了启动一个子进程并等待其结束：
from multiprocessing import Process
import os

# 子进程要执行的代码
def run_proc(name):
    print('Run child process %s (%s)...' % (name, os.getpid()))

if __name__=='__main__':
    print('Parent process %s.' % os.getpid())
    p = Process(target=run_proc, args=('test',))
    print('Child process will start.')
    p.start()
    p.join()
    print('Child process end.')
执行结果如下：
Parent process 928.
Process will start.
Run child process test (929)...
Process end.
创建子进程时，只需要传入一个执行函数和函数的参数，创建一个Process实例，用start()方法启动，这样创建进程比fork()还要简单。
join()方法可以等待子进程结束后再继续往下运行，通常用于进程间的同步。
subprocess模块可以让我们非常方便地启动一个子进程，然后控制其输入和输出。
下面的例子演示了如何在Python代码中运行命令nslookup www.python.org，这和命令行直接运行的效果是一样的：
import subprocess

print('$ nslookup www.python.org')
r = subprocess.call(['nslookup', 'www.python.org'])
print('Exit code:', r)
父进程所有Python对象都必须通过pickle序列化再传到子进程去，
Python的标准库提供了两个模块：_thread和threading，_thread是低级模块，threading是高级模块，对_thread进行了封装。绝大多数情况下，我们只需要使用threading这个高级模块。
启动一个线程就是把一个函数传入并创建Thread实例，然后调用start()开始执行：
import time, threading

# 新线程执行的代码:
def loop():
    print('thread %s is running...' % threading.current_thread().name)
    n = 0
    while n < 5:
        n = n + 1
        print('thread %s >>> %s' % (threading.current_thread().name, n))
        time.sleep(1)
    print('thread %s ended.' % threading.current_thread().name)

print('thread %s is running...' % threading.current_thread().name)
t = threading.Thread(target=loop, name='LoopThread')
t.start()
t.join()
print('thread %s ended.' % threading.current_thread().name)
多线程和多进程最大的不同在于，多进程中，同一个变量，各自有一份拷贝存在于每个进程中，互不影响，而多线程中，所有变量都由所有线程共享，所以，任何一个变量都可以被任何一个线程修改，因此，线程之间共享数据最大的危险在于多个线程同时改一个变量，把内容给改乱了。。创建一个锁就是通过threading.Lock()来实现：
balance = 0
lock = threading.Lock()

def run_thread(n):
    for i in range(100000):
        # 先要获取锁:
        lock.acquire()
        try:
            # 放心地改吧:
            change_it(n)
        finally:
            # 改完了一定要释放锁:
            lock.release()
ThreadLocal应运而生，不用查找dict，ThreadLocal帮你自动做这件事：
import threading

# 创建全局ThreadLocal对象:
local_school = threading.local()

def process_student():
    # 获取当前线程关联的student:
    std = local_school.student
    print('Hello, %s (in %s)' % (std, threading.current_thread().name))

def process_thread(name):
    # 绑定ThreadLocal的student:
    local_school.student = name
    process_student()

t1 = threading.Thread(target= process_thread, args=('Alice',), name='Thread-A')
t2 = threading.Thread(target= process_thread, args=('Bob',), name='Thread-B')
t1.start()
t2.start()
t1.join()
t2.join()
执行结果：
Hello, Alice (in Thread-A)
Hello, Bob (in Thread-B)
全局变量local_school就是一个ThreadLocal对象，每个Thread对它都可以读写student属性，但互不影响。你可以把local_school看成全局变量，但每个属性如local_school.student都是线程的局部变量，可以任意读写而互不干扰，也不用管理锁的问题，ThreadLocal内部会处理。
可以理解为全局变量local_school是一个dict，不但可以用local_school.student，还可以绑定其他变量，如local_school.teacher等等。
ThreadLocal最常用的地方就是为每个线程绑定一个数据库连接，HTTP请求，用户身份信息等，这样一个线程的所有调用到的处理函数都可以非常方便地访问这些资源。
分布式进程
通过managers模块把Queue通过网络暴露出去，就可以让其他机器的进程访问Queue了。
我们先看服务进程，服务进程负责启动Queue，把Queue注册到网络上，然后往Queue里面写入任务：
# task_master.py

import random, time, queue
from multiprocessing.managers import BaseManager

# 发送任务的队列:
task_queue = queue.Queue()
# 接收结果的队列:
result_queue = queue.Queue()

# 从BaseManager继承的QueueManager:
class QueueManager(BaseManager):
    pass

# 把两个Queue都注册到网络上, callable参数关联了Queue对象:
QueueManager.register('get_task_queue', callable=lambda: task_queue)
QueueManager.register('get_result_queue', callable=lambda: result_queue)
# 绑定端口5000, 设置验证码'abc':
manager = QueueManager(address=('', 5000), authkey=b'abc')
# 启动Queue:
manager.start()
# 获得通过网络访问的Queue对象:
task = manager.get_task_queue()
result = manager.get_result_queue()
# 放几个任务进去:
for i in range(10):
    n = random.randint(0, 10000)
    print('Put task %d...' % n)
    task.put(n)
# 从result队列读取结果:
print('Try get results...')
for i in range(10):
    r = result.get(timeout=10)
    print('Result: %s' % r)
# 关闭:
manager.shutdown()
print('master exit.')
请注意，当我们在一台机器上写多进程程序时，创建的Queue可以直接拿来用，但是，在分布式多进程环境下，添加任务到Queue不可以直接对原始的task_queue进行操作，那样就绕过了QueueManager的封装，必须通过manager.get_task_queue()获得的Queue接口添加。
然后，在另一台机器上启动任务进程（本机上启动也可以）：
# task_worker.py

import time, sys, queue
from multiprocessing.managers import BaseManager

# 创建类似的QueueManager:
class QueueManager(BaseManager):
    pass

# 由于这个QueueManager只从网络上获取Queue，所以注册时只提供名字:
QueueManager.register('get_task_queue')
QueueManager.register('get_result_queue')

# 连接到服务器，也就是运行task_master.py的机器:
server_addr = '127.0.0.1'
print('Connect to server %s...' % server_addr)
# 端口和验证码注意保持与task_master.py设置的完全一致:
m = QueueManager(address=(server_addr, 5000), authkey=b'abc')
# 从网络连接:
m.connect()
# 获取Queue的对象:
task = m.get_task_queue()
result = m.get_result_queue()
# 从task队列取任务,并把结果写入result队列:
for i in range(10):
    try:
        n = task.get(timeout=1)
        print('run task %d * %d...' % (n, n))
        r = '%d * %d = %d' % (n, n, n*n)
        time.sleep(1)
        result.put(r)
    except Queue.Empty:
        print('task queue is empty.')
# 处理结束:
print('worker exit.')
任务进程要通过网络连接到服务进程，所以要指定服务进程的IP。
现在，可以试试分布式进程的工作效果了。先启动task_master.py服务进程：
$ python3 task_master.py 
Put task 3411...
Put task 1605...
Put task 1398...
Put task 4729...
Put task 5300...
Put task 7471...
Put task 68...
Put task 4219...
Put task 339...
Put task 7866...
Try get results...
task_master.py进程发送完任务后，开始等待result队列的结果。现在启动task_worker.py进程：
$ python3 task_worker.py
Connect to server 127.0.0.1...
run task 3411 * 3411...
run task 1605 * 1605...
run task 1398 * 1398...
run task 4729 * 4729...
run task 5300 * 5300...
run task 7471 * 7471...
run task 68 * 68...
run task 4219 * 4219...
run task 339 * 339...
run task 7866 * 7866...
worker exit.
task_worker.py进程结束，在task_master.py进程中会继续打印出结果：
Result: 3411 * 3411 = 11634921
Result: 1605 * 1605 = 2576025
Result: 1398 * 1398 = 1954404
Result: 4729 * 4729 = 22363441
Result: 5300 * 5300 = 28090000
Result: 7471 * 7471 = 55815841
Result: 68 * 68 = 4624
Result: 4219 * 4219 = 17799961
Result: 339 * 339 = 114921
Result: 7866 * 7866 = 61873956
这个简单的Master/Worker模型有什么用？其实这就是一个简单但真正的分布式计算，把代码稍加改造，启动多个worker，就可以把任务分布到几台甚至几十台机器上，比如把计算n*n的代码换成发送邮件，就实现了邮件队列的异步发送。
Queue对象存储在哪？注意到task_worker.py中根本没有创建Queue的代码，所以，Queue对象存储在task_master.py进程中：
而Queue之所以能通过网络访问，就是通过QueueManager实现的。由于QueueManager管理的不止一个Queue，所以，要给每个Queue的网络调用接口起个名字，比如get_task_queue。
authkey有什么用？这是为了保证两台机器正常通信，不被其他机器恶意干扰。如果task_worker.py的authkey和task_master.py的authkey不一致，肯定连接不上。
正则表达式
用\d可以匹配一个数字，\w可以匹配一个字母或数字，.可以匹配任意字符，要匹配变长的字符，在正则表达式中，用*表示任意个字符（包括0个），用+表示至少一个字符，用?表示0个或1个字符，用{n}表示n个字符，用{n,m}表示n-m个字符：\s可以匹配一个空格。^表示行的开头，^\d表示必须以数字开头。$表示行的结束，\d$表示必须以数字结束。\w匹配字母数字，\W匹配非字母数字
s = 'ABC\\-001' # Python的字符串
因此我们强烈建议使用Python的r前缀，就不用考虑转义的问题了：
s = r'ABC\-001' # Python的字符串
# 对应的正则表达式字符串不变：
# 'ABC\-001'
re.split
可以使用re.split来分割字符串，如：re.split(r’\s+’, text)；将字符串按空格分割成一个单词列表。
原型： 
re.split(pattern, string, maxsplit=0)
通过正则表达式将字符串分离。如果用括号将正则表达式括起来，那么匹配的字符串也会被列入到list中返回。maxsplit是分离的次数，maxsplit=1分离一次，默认为0，不限制次数。
例如：
re.split(‘\W+’, ‘Words, words, words.’) 
[‘Words’, ‘words’, ‘words’, ”]
如果字符串不能匹配，将会返回整个字符串的list。
re.split(“a”,”bbb”) 
[‘bbb’]
re.match函数
re.match 尝试从字符串的起始位置匹配一个模式，如果不是起始位置匹配成功的话，match()就返回none。
re.search 扫描整个字符串并返回第一个成功的匹配。
import re
print(re.match('www', 'www.runoob.com').span())  # 在起始位置匹配
print(re.match('com', 'www.runoob.com'))         # 不在起始位置匹配
以上实例运行输出结果为：
(0, 3)
None
import re
print(re.search('www', 'www.runoob.com').span())  # 在起始位置匹配
print(re.search('com', 'www.runoob.com').span())         # 不在起始位置匹配
以上实例运行输出结果为：
(0, 3)
(11, 14)
re.compile
　　可以把正则表达式编译成一个正则表达式对象。可以把那些经常使用的正则表达式编译成正则表达式对象，这样可以提高一定的效率。
re.findall
re.findall可以获取字符串中所有匹配的字符串。如：re.findall(r'\w*oo\w*', text)；获取字符串中，包含'oo'的所有单词。

re.split('\W+', 'Words, words, words.')
['Words', 'words', 'words', '']
re.split('(\W+)', 'Words, words, words.')
['Words', ', ', 'words', ', ', 'words', '.', '']
•	如果没有加小括号，则返回结果就是用正则表达式匹配的groups；
•	如果加了小括号，会返回所有的groups，包括不匹配的groups也会包括在返回结果中。
•	分组
•	除了简单地判断是否匹配之外，正则表达式还有提取子串的强大功能。用()表示的就是要提取的分组（Group）。比如：
•	^(\d{3})-(\d{3,8})$分别定义了两个组，可以直接从匹配的字符串中提取出区号和本地号码：
•	>>> m = re.match(r'^(\d{3})-(\d{3,8})$', '010-12345')
•	>>> m
•	<_sre.SRE_Match object; span=(0, 9), match='010-12345'>
•	>>> m.group(0)
•	'010-12345'
•	>>> m.group(1)
•	'010'
•	>>> m.group(2)
•	'12345'
•	如果正则表达式中定义了组，就可以在Match对象上用group()方法提取出子串来。
•	注意到group(0)永远是原始字符串，group(1)、group(2)……表示第1、2、……个子串。
•	贪婪匹配
•	最后需要特别指出的是，正则匹配默认是贪婪匹配，也就是匹配尽可能多的字符。举例如下，匹配出数字后面的0：
•	>>> re.match(r'^(\d+)(0*)$', '102300').groups()
•	('102300', '')
•	由于\d+采用贪婪匹配，直接把后面的0全部匹配了，结果0*只能匹配空字符串了。
•	必须让\d+采用非贪婪匹配（也就是尽可能少匹配），才能把后面的0匹配出来，加个?就可以让\d+采用非贪婪匹配：
•	>>> re.match(r'^(\d+?)(0*)$', '102300').groups()
•	('1023', '00')
常用内建模块：
datetime是Python处理日期和时间的标准库
from datetime import datetime
注意到datetime是模块，datetime模块还包含一个datetime类，通过from datetime import datetime导入的才是datetime这个类。
如果仅导入import datetime，则必须引用全名datetime.datetime
把一个datetime类型转换为timestamp只需要简单调用timestamp()方法：
要把timestamp转换为datetime，使用datetime提供的fromtimestamp()方法
首先必须把str转换为datetime。转换方法是通过datetime.strptime()实现，需要一个日期和时间的格式化字符串。如果已经有了datetime对象，要把它格式化为字符串显示给用户，就需要转换为str，转换方法是通过strftime()实现的，同样需要一个日期和时间的格式
datetime加减
对日期和时间进行加减实际上就是把datetime往后或往前计算，得到新的datetime。加减可以直接用+和-运算符，不过需要导入timedelta这个类：
>>> from datetime import datetime, timedelta
>>> now = datetime.now()
>>> now
datetime.datetime(2015, 5, 18, 16, 57, 3, 540997)
>>> now + timedelta(hours=10)
collections是Python内建的一个集合模块，提供了许多有用的集合类。namedtuple
>>> from collections import namedtuple
>>> Point = namedtuple('Point', ['x', 'y'])
>>> p = Point(1, 2)
>>> p.x
1
>>> p.y
2
namedtuple是一个函数，它用来创建一个自定义的tuple对象，并且规定了tuple元素的个数，并可以用属性而不是索引来引用tuple的某个元素。
collections
阅读: 90196
________________________________________
collections是Python内建的一个集合模块，提供了许多有用的集合类。
namedtuple
我们知道tuple可以表示不变集合，例如，一个点的二维坐标就可以表示成：
>>> p = (1, 2)
但是，看到(1, 2)，很难看出这个tuple是用来表示一个坐标的。
定义一个class又小题大做了，这时，namedtuple就派上了用场：
>>> from collections import namedtuple
>>> Point = namedtuple('Point', ['x', 'y'])
>>> p = Point(1, 2)
>>> p.x
1
>>> p.y
2
namedtuple是一个函数，它用来创建一个自定义的tuple对象，并且规定了tuple元素的个数，并可以用属性而不是索引来引用tuple的某个元素。
这样一来，我们用namedtuple可以很方便地定义一种数据类型，它具备tuple的不变性，又可以根据属性来引用，使用十分方便。
可以验证创建的Point对象是tuple的一种子类：
>>> isinstance(p, Point)
True
>>> isinstance(p, tuple)
True
类似的，如果要用坐标和半径表示一个圆，也可以用namedtuple定义：
# namedtuple('名称', [属性list]):
Circle = namedtuple('Circle', ['x', 'y', 'r'])
deque
使用list存储数据时，按索引访问元素很快，但是插入和删除元素就很慢了，因为list是线性存储，数据量大的时候，插入和删除效率很低。
deque是为了高效实现插入和删除操作的双向列表，适合用于队列和栈：
>>> from collections import deque
>>> q = deque(['a', 'b', 'c'])
>>> q.append('x')
>>> q.appendleft('y')
>>> q
deque(['y', 'a', 'b', 'c', 'x'])
deque除了实现list的append()和pop()外，还支持appendleft()和popleft()，这样就可以非常高效地往头部添加或删除元素
defaultdict
使用dict时，如果引用的Key不存在，就会抛出KeyError。如果希望key不存在时，返回一个默认值，就可以用defaultdict：
>>> from collections import defaultdict
>>> dd = defaultdict(lambda: 'N/A')
>>> dd['key1'] = 'abc'
>>> dd['key1'] # key1存在
'abc'
>>> dd['key2'] # key2不存在，返回默认值
'N/A'
注意默认值是调用函数返回的，而函数在创建defaultdict对象时传入。
除了在Key不存在时返回默认值，defaultdict的其他行为跟dict是完全一样的
OrderedDict
使用dict时，Key是无序的。在对dict做迭代时，我们无法确定Key的顺序。
如果要保持Key的顺序，可以用OrderedDict：注意，OrderedDict的Key会按照插入的顺序排列，不是Key本身排序：
Counter
Counter是一个简单的计数器，例如，统计字符出现的个数：
>>> from collections import Counter
>>> c = Counter()
>>> for ch in 'programming':
...     c[ch] = c[ch] + 1
...
>>> c
Counter({'g': 2, 'm': 2, 'r': 2, 'a': 1, 'i': 1, 'o': 1, 'n': 1, 'p': 1})
Counter实际上也是dict的一个子类，上面的结果可以看出，字符'g'、'm'、'r'各出现了两次，其他字符各出现了一次




