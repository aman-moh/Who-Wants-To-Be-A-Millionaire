<h1>Who Wants To Be A Millionaire</h1>

<h2>Intent</h2>
*"Every journey begins with the first step of articulating the intention, and then becoming the intention.” - Bryant McGill, Voice of Reason*

The intention of this project is to create something that touches all areas of my current skillset and improves on the areas where I could be better. In a broad sense, this project will focus on areas such as Infrastructure, Networking, AI and Azure. All such areas will include resources that I am either familiar or unfamiliar with.

My initial idea for this project is to create something that touches those areas of development especially Artificial Intelligence alongside the objectives laid out in my appraisal review.

The idea for the project that I have thought is a program that would take information online from existing wikis that is related to any entertainment such as video games, TV shows or movies and turn it in to a quiz based game off the popular "Who Wants To Be A Millionaire" (WWTBAM for short).

The game would be GUI based written in python that would be picking out questions from the Wikipedia provided by the user. In this example I will be using the [Marvel Cinematic Universe](https://en.wikipedia.org/wiki/Marvel_Cinematic_Universe).

The program should be able to use a LLM to create sets of questions and answers that would test the user. The notable thing about the program is that it will ask about any Wikipedia page that the user enters giving it's uniqueness with the ability to use AI.


<h2>Planned Architecture</h2>

The planned architecture will be sum of its parts:

Frontend
Python Program
Pictures Folder
Backend
- Function App
- Infrastructure As Code
- Virtual Network

![Architecture Diagram](./million_pics/WWTBAM%20Diagram.drawio.png)

<h3>GitHub Actions</h3>

GitHub Actions similar to Azure DevOps allows to automate development using Continuous Integration and Continuous Deployment (CI/CD)
- Enabling of automating build, testing and deployment pipeline.
- Creating workflows to automatically build and test every pull request to the repository.

## Reason to pick GitHub Actions over Azure DevOps 
- Seamless integration
	- With Azure, creating a workflow config file is a simple process that sets up in the repository itself.
- Less experience in GitHub Actions
	- As a user with constant experience in Azure DevOps, I have decided to use GitHub actions to try get out of my comfort zone and get familiarized with other technologies.

## Issues and Resolutions

With every new instances of technologies being used, there's always a learning curve. With the starting addition of the workflow configuration file in the WWTBAM repository, the workflow would *strangely* fail. I use strangely because even though it would fail the workflow config file, the static web app that has been deployed would update with changes that are made in the index.html file.

Afterwards, when checking the Actions page out of GitHub, I realized there's also strangely two-three workflows set up that would run whenever there was any changes made to the GitHub repository. 


Some of it would be unnecessary as from the picture above, I would be deploying a static web app, not a ASP.NET Core project. This prompted me to diagnose the workflows and disable the ones that are irrelevant to me. 

However, the issue of the static web app workflow failing but still manging deploy the changes had me looking more closely to the actual workflow.  Specifically the Build and Deploy part of the workflow as that was the one giving the most issues.

The issues were primarily relating to:
- index.html file not being found
- outputter_location causing errors
- app_location causing errors

This prompted me to research the correct path for the variables to allow for these changes:
- app_location being changed from ==/index.html== to ==/==
- output_location being changed from ==/== to ==./== 


The reasons for these changes could be attributed to the deploy container was based in Ubuntu, which could be confusing the file folder structure. Allowing for these changes now makes the workflow run smoothly.

[test change · aman-moh/Who-Wants-To-Be-A-Millionaire@9e7f564 (github.com)](https://github.com/aman-moh/Who-Wants-To-Be-A-Millionaire/actions/runs/8925216514/job/24513387520)


## Action Secrets and Variables Clean-up

After cleaning up the workflows, I had to look in to the secrets section of the GitHub Repository and see that there's plenty of secrets there from when previous attempts of deploying resources were made. 

Cleaning up the section allowed me to verify the resources that are being utilized.

Although whenever the resource is destroyed and rebuilt, the deployment token needs to be updated in the section.

## Encountering 502 Bad Gateway App

Through extensive application 


<h2>Conclusions</h2>

