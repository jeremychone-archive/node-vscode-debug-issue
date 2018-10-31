
This repo is to illustrate a new bug that occured when upgrading to node.js 10.12 (from node 10.11) which prevent VSCode to find the source debug files. 

To reproduce this issue (with VSCode 1.28.2)

#### 1) Build the two docker images

- Create the two docker images (the one that works and the one that does not)

```sh

docker build --rm --no-cache -f Dockerfile-10-11 -t test-node-10-11:latest ./

docker build --rm --no-cache -f Dockerfile-10-12 -t test-node-10-12:latest ./

```

- Put break point in `dist/start.js` line 11 for example (inside requestHandler function)

#### 2) Test vscode with node 10.11 (should work)

- make sure nothing is running in port 9229 and 8080.

- start docker node 10.11 image
  - `docker run -p 8080:8080 -p 9229:9229 -it --rm test-node-10-11`

- check by going to http://localhost:8080/

- start debug session `Attach to docker nodejs`

- reload http://localhost:8080/

> **Expected == Actual:** All should be working, the breakpoint happen on line 11 of `file dist/start.js`

#### 3) Test with node 10.12 (should only debug 'read only file')

- shutdown previous docker image

- start docker image `test-node-10-12`
  - `docker run -p 8080:8080 -p 9229:9229 -it --rm test-node-10-12`


- test by going to http://localhost:8080/

- start debug session `Attach to docker nodejs`

- reload http://localhost:8080/

> **Expected:** Works a #2, debug original file

> **Actual:** The break point works, but on another tab named "start.js read-only core module"

**Note** Things get even trickier when we have some `.map` files and many time breakpoints on source .ts files for example are not enabled/active. 