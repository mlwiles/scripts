import datetime

def get_current_time():
    try:
        # Convert timestamp to datetime object
        # Get current time
        current_time = datetime.datetime.now()
        return current_time.strftime("%Y-%m-%d %H:%M:%S")
    
    except Exception as e:
        return f"Error: {e}"

def read_timestamp_from_file(file_name):
    try:
        with open(file_name, 'r') as file:
            line = file.readline()
            print(f'{line}')
            timestamp = datetime.datetime.strptime(line, "%Y-%m-%d %H:%M:%S")
        return timestamp
    except FileNotFoundError:
        print(f"Error: File '{file_name}' not found.")
        return None
    except Exception as e:
        print(f"Error: {e}")
        return None

def save_current_time_to_file(file_name, current_time):
    try:
        with open(file_name, 'w') as file:
            file.write(str(current_time))
        print(f"Current time saved to '{file_name}'.")
    except Exception as e:
        print(f"Error: {e}")

# Example usage:
if __name__ == "__main__":
    file_name = input("Enter the file name: ")
    timestamp = read_timestamp_from_file(file_name)
    if timestamp is not None:
        print("Old timestamp:", timestamp)
        current_time = get_current_time()
        print("Current time is:", current_time)
        save_current_time_to_file(file_name, current_time)
