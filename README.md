2 R Scripts have been created thus far.

----------------------------------------------------------------------------------------------------------------
'altageEVStationDT.R': 
- Uses a machine learning model known as Decision Tree with the charge cycle data provided by Hawaiian electric in order to calculate the probability of the Session Amount of a charge cycle being correct or wrong (with regards to the theoretical amount), given other attributes (columns).
- A graph is displayed at the end of the script that displays the results of the Decision Tree classification.
- This is meant to allow Hawaiian Electric to better understand patterns that might be causing errors in the EV charging stations.
----------------------------------------------------------------------------------------------------------------
'altageEVStationSVM.R':
- Uses a machine learning model known as Support Vector Machine (SVM) with the charge cycle data provided by Hawaiian electric in order to predict whether a session amount will be classified as correct or wrong (with regards to the theoretical amount), given certain values for the other attributes (columns) in the data set.
- A text output is displayed at the end of the program that displays the accuracy of the model and furthermore, the predictions will be stored in a variable known as 'test_pred'
----------------------------------------------------------------------------------------------------------------
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
