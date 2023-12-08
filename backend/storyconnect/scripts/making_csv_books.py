import pandas as pd

data = pd.read_csv("booktesting9.csv")

# Reverse rows using iloc() Function
data = data.tail(data.shape[0] - 1)
# data = data.drop(data['booktesting'],axis=1)
# Data_reverse_row_1 = data.iloc[::]

# add_col = ['user', 'target_audience', 'book_status', 'cover','modified', 'synopsis', 'copyright' ,'titlepage']
data_t = data.transpose()
print(data_t.columns)
data_t.rename(
    columns={1: "title", 2: "author", 3: "language", 4: "subject", 5: "released date"},
    inplace=True,
)
data_t["user"] = [3, 3, 3, 3, 3, 3, 3, 3, 3, 3]
data_t["target_audience"] = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
data_t["book_status"] = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
data_t["modified"] = ["", "", "", "", "", "", "", "", "", ""]
data_t["synopsis"] = ["", "", "", "", "", "", "", "", "", ""]
data_t["copyright"] = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
data_t["titlepage"] = ["", "", "", "", "", "", "", "", "", ""]
# data_t = data_t.tail(data.shape[0]-1)
field_names = [
    "title",
    "author",
    "user",
    "language",
    "target_audience",
    "book_status",
    "tags",
    "cover",
    "created",
    "modified",
    "synopsis",
    "copyright",
    "titlepage",
]
data_t = data_t.reindex(columns=field_names)

# # You can also try
# df = df.reindex(['Courses','Duration','Fee','Discount'], axis=1)
# Observe the result
# print(data_t.head())
data_t.to_csv("booktesting7.csv")
