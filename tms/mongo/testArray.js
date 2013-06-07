var arr1 = [];
arr1.push({'c':99,'d':2});
arr1.push({'c':2,'d':100});

print(arr1);
print("========");

var arr2 = [];
arr2.push({'c':29,'d':32});
arr2.push({'c':56,'d':8765});

print(arr2);
print("========");

arr1.push.apply(arr1,arr2);
print("print Array 1111111")
printjson(arr1)
