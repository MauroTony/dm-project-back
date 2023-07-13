from main import database

def blocklist(token: str):
    database.blocklist.insert_one({'token': token})
    return 'Token blocked successfully'
