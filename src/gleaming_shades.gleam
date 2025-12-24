import cards
import gleam/option
import gleam/uri.{type Uri}
import lustre
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html
import modem

pub fn main() {
  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

type Model {
  Model(route: Route)
}

type Route {
  Index
  Cards
  NotFound(uri: Uri)
}

fn parse_route(uri: Uri) -> Route {
  case uri.path_segments(uri.path) {
    [] | [""] -> Index

    ["cards"] -> Cards

    _ -> NotFound(uri:)
  }
}

fn init(_) -> #(Model, Effect(Msg)) {
  let route = case modem.initial_uri() {
    Ok(uri) -> parse_route(uri)
    Error(_) -> Index
  }

  let model = Model(route:)

  let effect =
    modem.init(fn(uri) {
      uri
      |> parse_route
      |> UserNavigatedTo
    })

  #(model, effect)
}

type Msg {
  UserNavigatedTo(route: Route)
}

fn update(_model: Model, msg: Msg) -> #(Model, Effect(Msg)) {
  case msg {
    UserNavigatedTo(route:) -> #(Model(route:), effect.none())
  }
}

fn view(model: Model) -> Element(Msg) {
  let content = case model.route {
    Cards -> {
      [
        cards.view(
          id: "infocard",
          classes: [],
          card: cards.InfoCard(
            "This is an info card",
            "This is the info. It's amazing and can be customised to how you like!",
            option.Some(html.button([], [html.text("A Button")])),
          ),
          addons: [],
        ),
        cards.view(
          id: "A List Card",
          classes: [],
          card: cards.ListCard(
            "ListCard",
            cards.Unordered,
            "This is the title of the list",
            [
              html.text("Abcd"),
              html.text("Efgh"),
            ],
          ),
          addons: [],
        ),
        cards.view(
          id: "abcd",
          classes: [],
          card: cards.ImageCard(
            "/spotify.png",
            "This is an image card",
            "abcd",
          ),
          addons: []
        )
      ]
    }

    _ -> [html.text("Wrong path")]
  }
  html.main([], content)
}
