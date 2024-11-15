if [[ $1 ]]
then

  #connect to data base
  PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only --no-align -c"

  QUERY_BASE="SELECT properties.atomic_number AS atomic_number,
                        properties.atomic_mass AS atomic_mass,
                        properties.melting_point_celsius AS melting_point_celsius,
                        properties.boiling_point_celsius AS boiling_point_celsius,
                        elements.symbol AS symbol,
                        elements.name AS name,
                        types.type AS type
                  FROM properties 
                  FULL JOIN elements 
                  ON properties.atomic_number = elements.atomic_number 
                  FULL JOIN types
                  ON properties.type_id = types.type_id"

  if [[ "$1" =~ ^[0-9]+$ ]]
  then
    QUERY="$QUERY_BASE WHERE properties.atomic_number = $1"
    
  elif [[ ${#1} -le 2 ]]
  then
    QUERY="$QUERY_BASE WHERE elements.symbol = '$1'"

  else
    QUERY="$QUERY_BASE WHERE elements.name = '$1'"
  fi
  
  RESULT=$($PSQL "$QUERY")

   if [[ -z "$RESULT" ]]; then
    echo "I could not find that element in the database."
  else
    IFS="|" read -r atomic_number atomic_mass melting_point_celsius boiling_point_celsius symbol name type <<< "$RESULT"

    echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point_celsius celsius and a boiling point of $boiling_point_celsius celsius."
  fi

else
  echo "Please provide an element as an argument."
fi

