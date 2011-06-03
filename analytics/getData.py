import json
import sys
import urllib

gname = "castlekd"
gid = 3
skey = "686246affc247204c0504d4a2bbabb91"
base_url = "http://centerforgamescience.com/cgs/apps/games/ws/index.php/logging"

def getActionForVersion(version, action):
	"""
	Takes two strings as parameters and returns an array of dictionary containing 
	the requested action from the requested version
	"""
	f = urllib.urlopen('%s/getactionsbyvid/?data={"g_name":"%s", "vid":"%s", "skey":"%s"}' % (base_url, gname, version, skey))
	data = f.read()
	actions = json.loads(data[5:])
	result = []
	for i in range(0, len(actions)):
		if actions[i]["aid"] == action or action == "0":
			result.append(actions[i])
	return result
	
def getQuestsForVersion(version, quest):
	"""
	Takes two strings as parameters and returns an array of dictionary containing 
	the requested action from the requested version
	"""
	f = urllib.urlopen('%s/getquests/?data={"g_name":"%s", "gid":"%s", "vid":"%s", "skey":"%s"}' % (base_url, gname, gid, version, skey))
	data = f.read()
	actions = json.loads(data[5:])
	result = []
	for i in range(0, len(actions)):
		if actions[i]["vid"] == version and (actions[i]["qid"] == quest or quest == "0"):
			result.append(actions[i])
	return result
	
if __name__ == "__main__":
	if len(sys.argv) < 4:
		print("Usage: python getData.py [action|quest] version_number [number|0]")
	else :
		kind = sys.argv[1]
		version = sys.argv[2]
		action = sys.argv[3]
		if kind == "action":
			actions = getActionForVersion(version, action)
			with open("action%sversion%s.csv" % (action, version), mode="w") as output:
				for i in range(0, len(actions)):
					uid = actions[i]["uid"]
					timestamp = actions[i]["ts"]
					detail = actions[i]["a_detail"][1:-1]
					fields = detail.split(",")
					if i == 0:
						s = "uid, timestamp, "
						for j in range(0, len(fields)):
							s += fields[j].split(":")[0] + ", "
						output.write(s[:-2] + "\n")
					s = "%s, %s, " % (uid, timestamp)
					for j in range(0, len(fields)):
						s += fields[j].split(":")[1] + ", "
					output.write(s[:-2] + "\n")
			print("Wrote data to file action%sversion%s.csv" % (action, version));
		elif kind == "quest":
			actions = getQuestsForVersion(version, action)
			with open("quest%sversion%s.csv" % (action, version), mode="w") as output:
				for i in range(0, len(actions)):
					uid = actions[i]["uid"]
					timestamp = actions[i]["log_q_ts"]
					detail = actions[i]["qid"]
					if i == 0:
						s = "uid, timestamp, qid"
					else:
						s = "%s, %s, %s" % (uid, timestamp, detail)
					output.write(s + "\n")
			print("Wrote data to file quest%sversion%s.csv" % (action, version));
			