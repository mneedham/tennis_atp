import csv
import pandas as pd
import math
import streamlit as st
import plotly.express as px

@st.cache  # 👈 Added this
def get_rankings():
    players = {}
    with open("atp_players.csv", "r") as players_file:
        reader = csv.DictReader(players_file)
        for row in reader:
            players[row["player_id"]] = row

    rows = []

    for rankings_file_name in ["atp_rankings_current.csv", "atp_rankings_20s.csv"]:
        with open(rankings_file_name, "r") as rankings_file:
            reader = csv.DictReader(rankings_file)
            for row in reader:
                player = players[row["player"]]
                rows.append({
                    "date": row["ranking_date"], 
                    "rank": int(row["rank"]), 
                    "points": int(row["points"]),
                    "player": f"{player['name_first']} {player['name_last']}"
                })
    return pd.DataFrame(rows)


st.header("ATP Rankings")

df = get_rankings()
df = df.sort_values(by='date')

players = st.multiselect(
     'Select players',
     df.sort_values(by='rank').player.unique(),
     ['Carlos Alcaraz'])

log_scale = st.checkbox('Log scale')     

df_filtered = df[df["player"].isin(players)]

fig = px.line(df_filtered, x='date', y="rank", color='player', log_y=log_scale, height=600)
fig['layout'].update(margin=dict(l=0,r=0,b=0,t=40), title="Rankings over time")

fig.update_layout(legend=dict(
    x = 0, 
    y = -0.2, 
    orientation = "h"
))

fig.update_xaxes(showspikes=True)
fig.update_yaxes(showspikes=True)

st.plotly_chart(fig, use_container_width=True)

fig = px.line(df_filtered, x='date', y="points", color='player', log_y=log_scale, height=600)
fig['layout'].update(margin=dict(l=0,r=0,b=0,t=40), title="Points over time")

fig.update_layout(legend=dict(
    x = 0, 
    y = -0.2, 
    orientation = "h"
))

fig.update_xaxes(showspikes=True)
fig.update_yaxes(showspikes=True)

st.plotly_chart(fig, use_container_width=True)