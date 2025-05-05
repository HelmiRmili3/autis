


This app have  actors :
   admin : acces the list of users patients , doctor
          vérify and   accept the doctor resquest to create account 
          bloc users from the app 
          





 * the app will contain jeux screen with multiple jeux ech one will take the user to levels screens for that jeux ech level will have x questions with 1 right answer for question .

 * 3 types of screen design 


 * signup and wait for confirmation from the admin 
   doctor app will accept patient invitation 
   generate reports based on the patient scores in the jeux details , 
   create sessions for ech patient 
   create new report for ech session


 * the patient will be eable to play 
   the parents will check the progress for the kid 


  * admin usecases :
          - /fetch doctors (ALL)
          - /fetch patients (ALL)
          - /verification de accounts des doctor (accept /refuse)(2)
          - /delete any user account (delete)(1)
          - /get comments fram all users (not importent)(1)(ALL)
  * doctor usecases:
          - /fetch all patients that they accepted there invite
          - /create /modifier /consulté les repports of patients(2)
          - /accepté / refusé les consultation(2)
          - /accepté / refusé les invitations from patients(2)
          - /get game history for the patients
          - /open /close /get games for patients (ALL)
  * patient usecases:
          - /consulté all the doctors send invite for one of them (2)(ALL)
          - /consulté all games for there kid(1)(ALL)
          - /update game history 
          - /consulté , / message bettween the parents and the doctor(2)
          - /create make appointement with doctor (1)
          - /consulté, rapport for there kid condition(1)(ALL)
          - /send , /consulté review to the admin if there is problem with the app(not importent)(2)
          - /add /delete /get album of photos for there kid


collections 
        users (patient , doctor , admin)

        games (patient game history)
          userId: 8DDUSJNSD8DSD
            [
                game1
                    score : 300
                    highlevel: 2
                    [
                    level1
                        levelscore: 30
                        lastquestionanswred : 3
                        stars:2
                        [
                        question1
                            try:3
                            last_answer : 1
                            [

                            ]
                        question2
                            .
                            .
                        ]
                    level2
                      .
                      .
                    ]
                game2
                  .
                  .

            ]
        reports (doctor patient reports)
        appointments (patient doctor appointments)
        invites (patient doctor invite plus conversations)d
        

        