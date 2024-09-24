#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
  then
    WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
    LOSER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
    
    if [[ -z $WINNER_ID ]]
    then
      INSERT_WINNER="$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"
    fi
    
    if [[ -z $LOSER_ID ]]
    then
      INSERT_LOSER="$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
    fi

    WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
    LOSER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
    INSERT_GAMES="$($PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES($YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS, $WINNER_ID, $LOSER_ID)")"
  fi
done