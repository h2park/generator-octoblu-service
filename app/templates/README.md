# <%= appName %>

[![Dependency status](http://img.shields.io/david/octoblu/<%= appName %>.svg?style=flat)](https://david-dm.org/octoblu/<%= appName %>)
[![devDependency Status](http://img.shields.io/david/dev/octoblu/<%= appName %>.svg?style=flat)](https://david-dm.org/octoblu/<%= appName %>#info=devDependencies)
[![Build Status](http://img.shields.io/travis/octoblu/<%= appName %>.svg?style=flat)](https://travis-ci.org/octoblu/<%= appName %>)

[![NPM](https://nodei.co/npm/<%= appName %>.svg?style=flat)](https://npmjs.org/package/<%= appName %>)

# Table of Contents

* [Introduction](#introduction)
* [Getting Started](#getting-started)
  * [Install](#install)
* [Usage](#usage)
  * [Default](#default)
  * [Docker](#docker)
    * [Development](#development)
    * [Production](#production)
  * [Debugging](#debugging)
  * [Test](#test)
* [License](#license)

# Introduction

...

# Getting Started

## Install

```bash
git clone <%= githubUrl %>/<%= fullFilePrefix %>.git
cd /path/to/<%= fullFilePrefix %>
npm install
```

# Usage

## Default

```javascript
node command.js
```

## Docker

### Development

```bash
docker build -t local/<%= appName %> .
docker run --rm -it --name <%= appName %>-local -p 8888:80 local/<%= appName %>
```

### Production

```bash
docker pull quay.io/octoblu/<%= appName %>
docker run --rm -p 8888:80 quay.io/octoblu/<%= appName %>
```

## Debugging

```bash
env DEBUG='<%= appName %>*' node command.js
```

```bash
env DEBUG='<%= appName %>*' node command.js
```

## Test

```bash
npm test
```

## License

MIT License

Copyright (c) 2017 Octoblu

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
