# Sign the RPM package

## Requirements

* O.S.: Redhat 7.

> It is recommended to use the same machine where the package have been created.

## Steps

### First, generate the key:
```
$ gpg --gen-key

```
> The command will ask you some questions.

Questions:

* Please select what kind of key you want: **DSA and ElGamal (default)**

* What keysize do you want? **4096** 

* Key is valid for? **0**
  > Recommended to set zero for no expiration. But you can put whatever period you judge as good.

* Real name: **FirstName LastName**

* Email address: **you@example.com**

* Comment: <nothing>
  > Nothing necessary here.

* Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? **O**

### Check if your key is in the list.

```
$ gpg --list-keys
```

You should see as output something like
```
pub  keysize/code Date YourNme <yourmail>
```

### Export the public key

```
$ gpg --export -a 'Your Name' > RPM-GPG-KEY-yourname
```

### Import into RPM
```
$ sudo rpm --import RPM-GPG-KEY-yourname
```

### Last check
Look into the file  ```~/.rpmmacros```, and there should be something like:
```
%_signature gpg
%_gpg_name  YourFirstName YourLastName
```

### Sign the package
```
$ rpm --addsign yourpackage.rpm
```

### Check signature
```
$ rpm --checksig yourpackage.rpm
```

## Reference
[This](http://fedoranews.org/tchung/gpg/) is the reference used for the current tutorial.
