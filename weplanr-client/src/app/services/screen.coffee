module = ->
  screens = [
    {
      type: "vendor"
      title: "How exciting!"
      subtitle: "So what can we help you with today?"
      option_text: "NO IDEA! HELP!"
      option: "register"
      enter: "search"
    },
    {
      type: "wedding_date"
      title: "That's okay! That's what we're here for!"
      subtitle: "Do you have a date in mind?"
      option_text: "DON'T KNOW YET"
      option: 3
      enter: 2
    },
    {
      type: "location"
      title: "Awesome!"
      subtitle: "Where are you thinking of getting married?"
      option_text: "NO CLUE!"
      option: "favorites"
      enter: "search"
    },
    {
      type: "location"
      title: "That's absolutely fine!"
      subtitle: "Where are you thinking of getting married?"
      option_text: "NO CLUE!"
      option: "favorites"
      enter: "search"
    }
  ]

  {
    getCurrentView: (val)->
      return screens[val]
  }


angular.module('client').factory('Screen', module)
