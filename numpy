
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
