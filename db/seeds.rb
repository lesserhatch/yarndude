# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create ten yarn types and colors
yarns = Yarn.create([
  {name: 'Dark Red',    color: 'b51b23',    short_name: 'Dark Red'    },
  {name: 'Red',         color: 'f92442',    short_name: 'Red'         },
  {name: 'Orange',      color: 'f42c18',    short_name: 'Orange'      },
  {name: 'Mango',       color: 'fa9131',    short_name: 'Mango'       },
  {name: 'Lemonade',    color: 'fae060',    short_name: 'Lemonade'    },
  {name: 'Green',       color: '55af66',    short_name: 'Green'       },
  {name: 'Cool Green',  color: '11988e',    short_name: 'Cool Green'  },
  {name: 'Ocean',       color: '327899',    short_name: 'Ocean'       },
  {name: 'Plum',        color: '5d3551',    short_name: 'Plum'        },
  {name: 'Fuchsia',     color: 'cf336a',    short_name: 'Fuchsia'     },
])

# Create a palette to use in development and add the yarn types created above to it
palette = Palette.create(name: 'Development')
temp = 110
yarns.each do |y|
  t = palette.temperature_ranges.new
  t.yarn = y
  t.high_temperature = temp
  t.low_temperature  = temp - 10
  t.save
  temp -= 11
end

# Create a blanket to use in development
blanket = Blanket.create({name: 'Test', email: 'swcharl@gmail.com', start_date: '2016-01-01', end_date: '2016-12-31', latitude: '36.15398159999999', longitude: '-95.992775'})
(blanket.start_date .. blanket.end_date).each do |date|
  d = blanket.days.new
  d.low_temperature = rand(1..70)
  d.high_temperature = rand(20..110)
  d.date = date
  d.save
end
