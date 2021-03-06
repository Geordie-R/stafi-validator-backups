
config_file="$HOME/geordiertools/config.ini"

function set_config_value(){
  #This replaces a key-pair value
  paramname=$(printf "%q" $1)
  paramvalue=$(printf "%q" $2)

  #echo $paramname
  #echo $paramvalue
  sed -i -E "s/^($paramname[[:blank:]]*=[[:blank:]]*).*/\1$paramvalue/" "$config_file"
}

#----------------------------------------------------------------------------------------------------#
# get_config_value: GLOBAL VALUE IS USED AS A GLOBAL VARIABLE TO RETURN THE RESULT                                     #
#----------------------------------------------------------------------------------------------------#

function get_config_value(){
  global_value=$(grep -v '^#' "$config_file" | grep "^$1=" | awk -F '=' '{print $2}')
if [ -z "$global_value" ]
  then
    return 1
  else
    return 0
  fi
}
