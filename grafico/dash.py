from dash import *
import plotly.express as px
import pandas as pd

app = Dash(__name__)

df = pd.DataFrame({
    "fruit":["apples","orange","banana","apples","orange"],
    "amount":[4,1,2,2,4],
    "city":["cuiaba","cuiaba","vg","montreal","cuiaba"]
})
fig = px.bar(df, x="fruta",y="amount",color="city",barmode="group")

app.layout = html.Div(children=[
    html.H1(children='hello word'),

    html.Div(children='''dashboard'''),

    dcc.Graph(
        id="example-graph",
        figure=fig

    )
])
if __name__=='__main__':
    app.run_server(debug=True)