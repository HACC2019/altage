# Recent Updates:
3 R Scripts have been created thus far.

----------------------------------------------------------------------------------------------------------------

1. 'altageEVStationDT.R': 

- Uses a machine learning model known as Decision Tree with the charge cycle data provided by Hawaiian electric in order to calculate the probability of the Session Amount of a charge cycle being correct or wrong (with regards to the theoretical amount), given other attributes (columns).
- A graph is displayed at the end of the script that displays the results of the Decision Tree classification.
- This is meant to allow Hawaiian Electric to better understand patterns that might be causing errors in the EV charging stations.
----------------------------------------------------------------------------------------------------------------------------

2. 'altageEVStationSVM.R':

- Uses a machine learning model known as Support Vector Machine (SVM) with the charge cycle data provided by Hawaiian electric in order to predict whether a session amount will be classified as correct or wrong (with regards to the theoretical amount), given certain values for the other attributes (columns) in the data set.
- A text output is displayed at the end of the program that displays the accuracy of the model and furthermore, the predictions will be stored in a variable known as 'test_pred'

Key to understand the processed dataset:
- Data After Manual Pre-Processing
- Charge Station Name: Categorical; 0=A, 1=B
- Session Intitiated By: Categorical; 0=Mobile, 1=Device, 2=Web
- TimeOfDay: Categorical; 0=Off-Peak, 1=Mid-Day, 2=On-Peak
- Duration (minutes): Continuous; -938.02 to 320.62
- Energy(kWh): Continuous; 0 to 84.65
- Session Amount ($): Continuous; 0 to 9.99
- Port Type: Categorical; 0=Chademo, 1=DCCOMBOTYP1
- Payment Mode: Categorical; 0=Credit Card, 1=RFID
- MonthOfYear: Categorical; 1=January...12=December
- DayOfWeek: Categorical; 1=Monday...7=Sunday

- Amount: Categorical Decicison Variable; 0=Amount spent is incorrect, 1=Amount spent is correct 	according to price points per kWh at given TimeOfDay
----------------------------------------------------------------------------------------------------------------------------

3. 'altageEVStationCongestion.R'

- Identifies when there is possible congestion at a given charging station.
- Congestion is determined by an assumption made (as no relative information was provided by Hawaiian Electric) that each car takes a maximum of 7 minutes to set-up at charing station before the session starts and that if a car starts a session within 7 minutes of another car ending a session, they have been waiting in line to charge.
- Therefore, the program looks for 3 cars in a row, where the time between two charge cycles (sessions) is less than 7 minutes and then indicates that there is congestion if those conditions are met, starting from the third car in line. The program then continues to indicate that there is congestion until a gap between charge cycles of over 7 minutes is found.
- The users of the application will eventually be able to manipulate the classifying factors (time and number of cars) of this congestion program throuhg the front end of the Altage application.
-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------

# Altage

Altage is a user-friendly web application implemented with Salesforce that solves the problem that Hawaiian Electric faces with regards to its EV charging stations placed around the State of Hawaii. Using the historical and trending data provided by Hawaiian electric, the application will provide a more elaborate insight on the health of a given charging station, congestion at a given charge station and the electric load of a DC fast charging station.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.


{Content below is in progress}

### Prerequisites {In progress}

What things you need to install the software and how to install them

```
Give examples
```

### Installing {In progress}

A step by step series of examples that tell you how to get a development environment running

Say what the step will be

```
Give the example
```

And repeat

```
until finished
```

End with an example of getting some data out of the system or using it for a little demo

## Running the tests {In progress}

Explain how to run the automated tests for this system

### Break down into end to end tests {In progress}

Explain what these tests test and why

```
Give an example
```

### And coding style tests {In progress}

Explain what these tests test and why

```
Give an example
```

## Deployment {In progress}

Add additional notes about how to deploy this on a live system

## Built With {In progress}

* [Salesforce](https://developer.salesforce.com/) - The web framework used to create the databases needed and the front end of the application.
* [?](?) - ??
* [?](?) - ??

## Contributing {In progress}

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning {In progress}

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors {In progress}

* **Billie Thompson** - *Initial work* - [PurpleBooth](https://github.com/PurpleBooth)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments {In progress}

* Hat tip to anyone whose code was used
* Inspiration
* Etc
