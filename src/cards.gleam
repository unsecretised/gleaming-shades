import gleam/list
import gleam/option
import lustre/attribute
import lustre/element
import lustre/element/html

pub type ListType {
  Unordered
  Ordered
}

pub type Card(value) {
  InfoCard(
    header: String,
    info: String,
    button: option.Option(element.Element(value)),
  )
  ListCard(
    header: String,
    list_type: ListType,
    list_info: String,
    list_elements: List(element.Element(value)),
  )
  ImageCard(image_path: String, header: String, info: String)
}

/// "Renders" your card to an element that you can plop into your code :)
pub fn view(
  id id: String,
  classes classes: List(#(String, Bool)),
  card card: Card(elm),
  addons addons: List(element.Element(elm)),
) -> element.Element(elm) {
  let class =
    case card {
      InfoCard(..) -> "infocard"
      ListCard(..) -> "listcard"
      ImageCard(..) -> "imagecard"
    }
    <> "-parent"

  let attributes = [
    attribute.id(id),
    attribute.classes(classes),
    attribute.class(class),
  ]

  let contents = case card {
    InfoCard(header, info, button) -> {
      [
        html.h3([attribute.class("infocard-h3")], [html.text(header)]),
        html.div([attribute.class("infocard-info")], [
          html.text(info),
        ]),
        option.unwrap(button, element.none()),
      ]
    }
    ListCard(card_header, list_type, list_info, list_elements) -> {
      let list_callback = case list_type {
        Ordered -> html.ol
        Unordered -> html.ul
      }

      let list_element_expansion = fn(elem) -> element.Element(a) {
        html.li([attribute.class("listcard-li")], [elem])
      }

      [
        html.h3([attribute.class("listcard-h3")], [
          html.text(card_header),
        ]),
        html.div([attribute.class("listcard-info")], [
            html.text(list_info),
        ]),
        list_callback(
          [attribute.class("listcard-list")],
          list.map(list_elements, list_element_expansion),
        ),
      ]
    }
    ImageCard(image_path, header, info) -> {
      [
        html.img([attribute.src(image_path), attribute.class("imagecard-img")]),
        html.div([attribute.class("imagecard-textdiv")], [
          html.h3([attribute.class("imagecard-h3")], [html.text(header)]),
          html.span([attribute.class("imagecard-info")], [html.text(info)]),
        ]),
      ]
    }
  }

  let contents = list.append(contents, addons)

  html.div(attributes, contents)
}
