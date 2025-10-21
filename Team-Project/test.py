import csv
from collections import defaultdict


def get_gymnastics_data(filename):
    gymnastics_data = []
    with open(filename, mode="r", newline="", encoding="utf-8") as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            if row.get("Sport") == "Gymnastics":
                gymnastics_data.append(row)
    # Sort the data by the 'Year' field as integer
    gymnastics_data.sort(key=lambda x: int(x.get("Year", 0)))
    return gymnastics_data


def export_to_csv(data, output_filename):
    if not data:
        return
    with open(output_filename, mode="w", newline="", encoding="utf-8") as csvfile:
        fieldnames = data[0].keys()
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(data)


def count_athletes_by_year_country(filename):
    counts = defaultdict(lambda: defaultdict(int))
    with open(filename, mode="r", newline="", encoding="utf-8") as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            year = row.get("Year")
            country = row.get("Team")
            if year and country:
                counts[int(year)][country] += 1
    # Flatten the counts into a list of dicts
    result = []
    for year in sorted(counts.keys()):
        for country, count in counts[year].items():
            result.append({"Year": year, "Country": country, "AthleteCount": count})
    return result


# Example usage
if __name__ == "__main__":
    filename = "Athletes_summer_games.csv"
    data = get_gymnastics_data(filename)
    export_to_csv(data, "result.csv")

    athlete_counts = count_athletes_by_year_country("result.csv")
    export_to_csv(athlete_counts, "athletes.csv")

    for entry in athlete_counts:
        print(entry)
