import datetime as dt
import matplotlib.pyplot as plt
import matplotlib.animation as animation
from firebase import firebase
import os

# declare a connection with the firebase
firebase = firebase.FirebaseApplication("https://ecg-project-75dd0.firebaseio.com/", None)

# graph and plotting configuration
fig = plt.figure()
ax = fig.add_subplot(1, 1, 1)
xs = []
ys = []

# keep track of the current value that are queried from firebase
index = 0

def animate(i, xs, ys):
    cur_value = 0

    # if there is no new data from database, then the graph is not going to plot
    # but wait for the data by using try and exception
    # if noData == True -> red LED blink
    # else -> getData() + plot graph
    try:
        cur_value = firebaseGet(None)
    except:
        os.system("make")
        os.system("sudo ./ass_light")
        print("Error!!!")
        return
    
    # if there is data, then plot the graph
    xs.append(dt.datetime.now().strftime('%H:%M:%S.%f'))
    ys.append(cur_value)
    xs = xs[-20:]
    ys = ys[-20:]

    ax.clear()
    ax.plot(xs, ys)

    # graph label and style configuration
    plt.xticks(rotation=45, ha='right')
    plt.subplots_adjust(bottom=0.30)
    plt.title('Heart Rate Pulse Monitor')
    plt.ylabel('Value')

# firebase api get() method
def firebaseGet(key):
    global index
    data = firebase.get('/value/', key)
    temp = list(data)[index]
    index += 1
    # return only value as extract from specific key of current value index
    return data[temp]

# driver code function
def main():
    # clear the data in the data first, before access.
    firebase.delete('/value', None)

    # initialize the animation for the graph ploting, then run the graph window
    ani = animation.FuncAnimation(fig, animate, fargs=(xs, ys), interval=1000)
    plt.show()

main()
