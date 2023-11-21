from ai_features import continuity_checker as cc


with open('ai_features/demo/grey.txt', 'r') as f:
    chapter = f.read()

print(len(chapter))

cont = cc.ContinuityCheckerChat()

statements = cont.create_statementsheet(chapter)

with open('ai_features/demo/grey_statements.txt', 'w') as f:
    f.write(statements)

with open('ai_features/demo/log.txt', 'w') as f:
    f.write(str(cont.last_response))
    f.write("\n\n")

filtered = cont.filter_statementsheet(statements)

with open('ai_features/demo/log.txt', 'a') as f:
    f.write(str(cont.last_response))

with open('ai_features/demo/grey_filtered.txt', 'w') as f:
    f.write(filtered)

with open('ai_features/demo/grey_state_con.txt', 'r') as f:
    contradicitions = f.read()

comparison = cont.compare_statementsheets(statements, contradicitions)

with open('ai_features/demo/log.txt', 'a') as f:
    f.write(str(cont.last_response))

with open('ai_features/demo/grey_comparison.txt', 'w') as f:
    f.write(comparison)







