# heroku-ocsigen

This is a Dockerfile for deploying the Ocaml [ocsigenserver](https://ocsigen.org) to Heroku as a Docker container.  

It runs the bare ocsigenserver.  Image size is 1.35GB.

**The image built contains the full Ocaml installation.  Please see [heroku-ocsigen-thin](https://github.com/wrmack/heroku-ocsigen-thin) or [heroku-ocsigen-start-thin](https://github.com/wrmack/heroku-ocsigen-start-thin/tree/master) for a Dockerfile that creates a much smaller image.**

## To deploy to Heroku

#### Create a Heroku app
```
cd to directory with this Dockerfile
heroku login
heroku container:login
heroku create *your-app-name*
```
#### Each time you make changes, push to Heroku and release
```

heroku container:push web --app *your-app-name*
heroku container:release web --app *your-app-name*
```
#### View on web
```
heroku open --app *your-app-name*
```

#### Inspect running Heroku app
- run a bash shell in the container
```
heroku run bash --app *your-app-name*
```
- view logs
```
heroku logs --tail --app *your-app-name*
```

## To test locally

- uncomment PORT, USER, GROUP variables in entrypoint.sh for local use and comment out the Heroku ones, then
```
docker build -t *your-image-name*
docker run -it -d --name *your-container-name* -p 8080:8080 *your-image-name*
```
- view on localhost:8080


Live site [here](https://ocsi-app4.herokuapp.com).  I am using the free tier so it takes a while (about 1 minute) to wake up a dyno if it is sleeping.  Not sure what happens under the hood.  Heroku possibly creates a new instance and so the whole image has to be copied.



