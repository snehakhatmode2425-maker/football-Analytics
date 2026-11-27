import streamlit as st
import pandas as pd
import plotly.express as px

st.set_page_config(
    page_title="Sneha Football Analytics",
    page_icon="⚽",
    layout="wide"
)

st.title("⚽ Football Analytics Dashboard")
st.subheader("Created by Sneha")
st.write("Analyze football players, teams, goals and performance.")

@st.cache_data
def load_data():
    return pd.read_csv("football_players.csv")

df = load_data()

st.sidebar.title("Dashboard Menu")

team_list = ["All Teams"] + sorted(df["team"].unique().tolist())
selected_team = st.sidebar.selectbox("Choose Team", team_list)

if selected_team != "All Teams":
    df = df[df["team"] == selected_team]

st.header("Dashboard Overview")

col1, col2, col3, col4 = st.columns(4)

col1.metric("Total Players", len(df))
col2.metric("Total Goals", int(df["goals"].sum()))
col3.metric("Total Assists", int(df["assists"].sum()))
col4.metric("Total Appearances", int(df["appearances"].sum()))

st.divider()

st.header("Player Performance")

goal_chart = px.bar(
    df,
    x="player_name",
    y="goals",
    color="team",
    title="Goals Scored by Players"
)

st.plotly_chart(goal_chart, use_container_width=True)

st.header("Team Analysis")

team_data = df.groupby("team", as_index=False)["goals"].sum()

team_chart = px.pie(
    team_data,
    names="team",
    values="goals",
    title="Goals by Team"
)

st.plotly_chart(team_chart, use_container_width=True)

st.header("Player Data Explorer")

search = st.text_input("Search Player")

if search:
    df = df[df["player_name"].str.contains(
        search, case=False, na=False
    )]

st.dataframe(df, use_container_width=True)

st.divider()
st.caption("Football Analytics Dashboard | Developed by Sneha")