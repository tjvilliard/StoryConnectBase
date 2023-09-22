import pandas as pd

data = pd.read_csv('booktesting7.csv')

chapters = data['chapteredcontent']

data['book_id'] = [78, 79, 80, 81, 82, 83, 84, 85, 86]
book_ids = data['book_id']

data = data.drop(columns=['Unnamed: 0'])

chapter_df = pd.DataFrame({
    'book': [0],
    'chapter_number': [0],
    'chapter_title': ['a'],
    'content': ['a']
})

chaps_b = {}
idx = 0
for i,row in enumerate(data['chapteredcontent'][0:]):
  chaps = []
  content_lst = row.split("***")
  content_lst = content_lst[2:-2]

  for i, c in enumerate(content_lst):
      content_lst[i] = ''.join(c.splitlines())
  content_lst = "".join(content_lst)

  # ipdb.set_trace()
  content_lst_ch = content_lst.split("CHAPTER ")
  for ch in content_lst_ch:
    chaps.append([ch])
  chaps_b[idx] = chaps
  idx += 1

chapter_df = pd.DataFrame({
    'book': [0],
    'chapter_number': [0],
    'chapter_title': ['a'],
    'content': ['a']
})
i = 0
for book in chaps_b.keys():
    for ch in chaps_b[book]:
        num = 0
        # for j in range(5):
        newch = {'book': book_ids[book],
          'chapter_number': num,
          'chapter_title': "Chapter "+ str(num),
          'content': ch}
        chapter_df = chapter_df.append(newch, ignore_index=True)
        num += 1
    i += 1