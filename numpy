
import numpy as np
mat()函数可以将数组转化为矩阵#randMat = mat(random.rand(4,4))
#求逆矩阵
randMat.I
eye(4)创建4X4的单位矩阵
tile函数    
    在看机器学习实战这本书时，遇到numpy.tile(A,B)函数，愣是没看懂怎么回事，装了numpy模块后，实验了几把，原来是这样子：

重复A，B次，这里的B可以时int类型也可以是远组类型。

[python] view plain copy
>>> import numpy  
>>> numpy.tile([0,0],5)#在列方向上重复[0,0]5次，默认行1次  
array([0, 0, 0, 0, 0, 0, 0, 0, 0, 0])  
>>> numpy.tile([0,0],(1,1))#在列方向上重复[0,0]1次，行1次  
array([[0, 0]])  
>>> numpy.tile([0,0],(2,1))#在列方向上重复[0,0]1次，行2次  
array([[0, 0],  
       [0, 0]])  
>>> numpy.tile([0,0],(3,1))  
array([[0, 0],  
       [0, 0],  
       [0, 0]])  
>>> numpy.tile([0,0],(1,3))#在列方向上重复[0,0]3次，行1次  
array([[0, 0, 0, 0, 0, 0]])  
>>> numpy.tile([0,0],(2,3))<span style="font-family: Arial, Helvetica, sans-serif;">#在列方向上重复[0,0]3次，行2次</span>  
array([[0, 0, 0, 0, 0, 0],  
       [0, 0, 0, 0, 0, 0]])  


sum():
c = np.array([[0, 2, 1], [3, 5, 6], [0, 1, 1]])
print c.sum()
print c.sum(axis=0)
print c.sum(axis=1)
结果分别是：19, [3 8 8], [ 3 14  2]


sorter()函数：
sort 与 sorted 区别：
sort 是应用在 list 上的方法，sorted 可以对所有可迭代的对象进行排序操作。
list 的 sort 方法返回的是对已经存在的列表进行操作，而内建函数 sorted 方法返回的是一个新的 list，而不是在原来的基础上进行的操作。
语法
sorted 语法：
sorted(iterable[, cmp[, key[, reverse]]])
参数说明：
iterable -- 可迭代对象。
cmp -- 比较的函数，这个具有两个参数，参数的值都是从可迭代对象中取出，此函数必须遵守的规则为，大于则返回1，小于则返回-1，等于则返回0。
key -- 主要是用来进行比较的元素，只有一个参数，具体的函数的参数就是取自于可迭代对象中，指定可迭代对象中的一个元素来进行排序。
reverse -- 排序规则，reverse = True 降序 ， reverse = False 升序（默认）
students = [('john', 'A', 15), ('jane', 'B', 12), ('dave', 'B', 10)]
sorted(students, key=lambda s: s[2]) #按年龄排序
# [('dave', 'B', 10), ('jane', 'B', 12), ('john', 'A', 15)]
一、lambda函数也叫匿名函数，即，函数没有具体的名称。先来看一个最简单例子：
def f(x):
return x**2
print f(4)
Python中使用lambda的话，写成这样
g = lambda x : x**2
print g(4)


字典(Dictionary) items()方法:
Python 字典(Dictionary) items() 函数以列表返回可遍历的(键, 值) 元组数组
语法
items()方法语法：
dict.items()
实例：
dict = {'Google': 'www.google.com', 'Runoob': 'www.runoob.com', 'taobao': 'www.taobao.com'}
 
print "字典值 : %s" %  dict.items()
 
# 遍历字典列表
for key,values in  dict.items():
    print key,values
以上实例输出结果为：
字典值 : [('Google', 'www.google.com'), ('taobao', 'www.taobao.com'), ('Runoob', 'www.runoob.com')]
Google www.google.com
taobao www.taobao.com
Runoob www.runoob.com

python中的operator.itemgetter函数：
operator.itemgetter函数
operator模块提供的itemgetter函数用于获取对象的哪些维的数据，参数为一些序号。
>>> import operator as op
>>> a=[('j','a',15),('ja','b',12),('jan','c',10)]
>>> b=op.itemgetter(1)
>>> b(a)
('ja', 'b', 12)
>>> b=op.itemgetter(1,0)
>>> b(a)
(('ja', 'b', 12), ('j', 'a', 15))
>>> b=op.itemgetter(1,2)
>>> b(a)
(('ja', 'b', 12), ('jan', 'c', 10))
要注意，operator.itemgetter函数获取的不是值，而是定义了一个函数，通过该函数作用到对象上才能获取值。

range(start, end, step)，返回一个list对象，起始值为start，终止值为end，但不含终止值，步长为step。只能创建int型list。
arange(start, end, step)，与range()类似，但是返回一个array对象。需要引入import numpy as np，并且arange可以使用float型数据。
>>> import numpy as np
>>> range(1,10,2)
[1, 3, 5, 7, 9]
>>> np.arange(1,10,2)
array([1, 3, 5, 7, 9])
>>> range(1,5,0.5)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: range() integer step argument expected, got float.
>>> np.arange(1,5,0.5)
array([ 1. ,  1.5,  2. ,  2.5,  3. ,  3.5,  4. ,  4.5])

Python3 split()方法:
split()通过指定分隔符对字符串进行切片，如果参数num 有指定值，则仅分隔 num 个子字符串
以下实例展示了split()函数的使用方法：
#!/usr/bin/python3
str = "this is string example....wow!!!"
print (str.split( ))
print (str.split('i',1))
print (str.split('w'))
以上实例输出结果如下：
['this', 'is', 'string', 'example....wow!!!']
['th', 's is string example....wow!!!']
['this is string example....', 'o', '!!!']


#注意：pyplot的方式中plt.subplot()参数和面向对象中的add_subplot()参数和含义都相同

#注意：xlabel()和set_xlabel()区别
1、fig = plt.figure()
ax = fig.add_subplot(111)
ax.set_xlabel('Percentage of Time Spent Playing Video Games')
2、import matplotlib.pyplot as plt
plt.xlabes('Percentage of Time Spent Playing Video Games')

numpy.meshgrid
meshgrid函数用两个坐标轴上的点在平面上画格
x = np.arange(-1, 1)
y = np.arange(-2, 2)
X, Y = np.meshgrid(x, y)
print(x)
print(y)
print(X)
print(Y)
x行数为Y的个数
[-1  0]
[-2 -1  0  1]
[[-1  0]
 [-1  0]
 [-1  0]
 [-1  0]]
[[-2 -2]
 [-1 -1]
 [ 0  0]
 [ 1  1]]
 
# R = np.sqrt(X**2 + Y**2)

Python中append和extend的区别
编者注：本文主要参考了《Python核心编程（第二版）》

网上有很多对这两个函数的区别讲解，但我觉得都讲的不是很清楚，记忆不深刻。这样解释清楚且容易记住。

list.append(object) 向列表中添加一个对象object
list.extend(sequence) 把一个序列seq的内容添加到列表中
music_media = ['compact disc', '8-track tape', 'long playing record']
new_media = ['DVD Audio disc', 'Super Audio CD']
music_media.append(new_media)
print music_media
>>>['compact disc', '8-track tape', 'long playing record', ['DVD Audio disc', 'Super Audio CD']]
使用append的时候，是将new_media看作一个对象，整体打包添加到music_media对象中。
music_media = ['compact disc', '8-track tape', 'long playing record']
new_media = ['DVD Audio disc', 'Super Audio CD']
music_media.extend(new_media)
print music_media
>>>['compact disc', '8-track tape', 'long playing record', 'DVD Audio disc', 'Super Audio CD']
使用extend的时候，是将new_media看作一个序列，将这个序列和music_media序列合并，并放在其后面。

set:set是一个无序且不重复的元素集合。set也有如下特性：
不重复
元素为不可变对象
a=set('boy')
b=set(['y', 'b', 'o','o'])
c=set({"k1":'v1','k2':'v2'})
d={'k1','k2','k2'}
e={('k1', 'k2','k2')}
print(a,type(a))
print(b,type(b))
print(c,type(c))
print(d,type(d))
print(e,type(e))

OUTPUT:
{'o', 'b', 'y'} <class 'set'>
{'o', 'b', 'y'} <class 'set'>
{'k1', 'k2'} <class 'set'>
{'k1', 'k2'} <class 'set'>
{('k1', 'k2', 'k2')} <class 'set'>
基于numpy库concatenate是一个非常好用的数组操作函数
concatenate((a1, a2, …), axis=0)
Parameters参数
传入的参数必须是一个多个数组的元组或者列表
另外需要指定拼接的方向，默认是 axis = 0，也就是说对0轴的数组对象进行纵向的拼接（纵向的拼接沿着axis= 1方向）；
注：一般axis = 0，就是对该轴向的数组进行操作，操作方向是另外一个轴，即axis=1。
In [23]: a = np.array([[1, 2], [3, 4]])

In [24]: b = np.array([[5, 6]])

In [25]: np.concatenate((a, b), axis=0)
Out[25]:
array([[1, 2],
       [3, 4],
       [5, 6]])

传入的数组必须具有相同的形状，这里的相同的形状可以满足在拼接方向axis轴上数组间的形状一致即可
如果对数组对象进行 axis= 1 轴的拼接，方向是横向0轴，a是一个2*2维数组，axis= 0轴为2，b是一个1*2维数组，axis= 0 是1，两者的形状不等，这时会报错
