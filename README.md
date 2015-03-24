[![Build Status](https://travis-ci.org/neoalienson/merchcircle-web.svg)](https://travis-ci.org/neoalienson/merchcircle-web)
[![Circle CI](https://circleci.com/gh/neoalienson/merchcircle-web.svg?style=svg)](https://circleci.com/gh/neoalienson/merchcircle-web)
[ ![Codeship Status for neoalienson/merchcircle-web](https://codeship.com/projects/426b7660-b42d-0132-7f0b-7e0b9cbc7ee6/status?branch=master)](https://codeship.com/projects/70396)

#Instastore

Sell your stuff quickly

#Getting Started

Run:

> mvn spring-boot:run to start the server

By default, you should see the page running on http://localhost:8080

#Mobile integration

##Post Product

Post product JSON:

	{
	  "id": "12345",
	  "name": "Red Bull Diet",
	  "description": "Red bull give you wings",
	  "price": 1.99,
	  "image": <base64 encoded image>
	}
	
HTTP POST to `//<hostname>:<port>/product`

##View posted product

View it at the following URL: `//<hostname>:<port>/product/<product id>`

# iOS App
Only `with_app` branch has the iOS app sources.

The reason to have `with_app` branch is for submission to hackathon. The app source is maintain at https://github.com/neoalienson/merchcircle-app
