import csv
import sys


def main():

    # TODO: Check for command-line usage
    if not len(sys.argv) == 3:
        print("Invalid input")

    dicty = {}

    # TODO: Read database file into a variable
    with open(sys.argv[1]) as csv_file:
        csv_reader = csv.reader(csv_file, delimiter = ',')
        list_of_column_names = []
        for row in csv_reader:
            list_of_column_names.append(row)
            break
    list = list_of_column_names[0]
    nameval = list[0]
    list.remove(list[0])

    with open(sys.argv[1]) as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            temp = []
            tempname = row[nameval]
            for each in range(0, len(list)):
                seq1 = int(row[list[each]])
                temp.append(seq1)
            dicty[tempname] = temp

    # TODO: Read DNA sequence file into a variable
    f = open(sys.argv[2], 'r')
    seq = f.read()

    # TODO: Find longest match of each STR in DNA sequence
    checklist = []
    for i in range(len(list)):
        checklist.append(longest_match(seq, list[i]))

    # TODO: Check database for matching profiles
    for each in dicty:
        if dicty[each] == checklist:
            print(each)
        
    return

def longest_match(sequence, subsequence):
    """Returns length of longest run of subsequence in sequence."""

    # Initialize variables
    longest_run = 0
    subsequence_length = len(subsequence)
    sequence_length = len(sequence)

    # Check each character in sequence for most consecutive runs of subsequence
    for i in range(sequence_length):

        # Initialize count of consecutive runs
        count = 0

        # Check for a subsequence match in a "substring" (a subset of characters) within sequence
        # If a match, move substring to next potential match in sequence
        # Continue moving substring and checking for matches until out of consecutive matches
        while True:

            # Adjust substring start and end
            start = i + count * subsequence_length
            end = start + subsequence_length

            # If there is a match in the substring
            if sequence[start:end] == subsequence:
                count += 1

            # If there is no match in the substring
            else:
                break

        # Update most consecutive matches found
        longest_run = max(longest_run, count)

    # After checking for runs at each character in seqeuence, return longest run found
    return longest_run


main()
