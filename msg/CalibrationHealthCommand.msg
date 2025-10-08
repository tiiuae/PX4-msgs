# CalibrationHealthCommand.msg
# Command to query sensor health status for calibration purposes

uint64 timestamp
uint8 target_system
uint8 target_component

# Command type
uint8 QUERY_HEALTH = 1
uint8 command