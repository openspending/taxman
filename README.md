TaxMan
======

TaxMan is a very early prototype of a universal tax calculator API. It's
running at <http://taxman.openspending.org>.

What does it do?
----------------

It provides a JSON API to find out tax rates for countries around the world,
and to perform the relevant calculations to work out what tax citizens pay
(and have paid in the past).

Get a list of jurisdictions currently supported by TaxMan:

    $ curl -s 'taxman.openspending.org'
    {
      "message": "Welcome to the TaxMan",
      "jurisdictions": {
        "gb": "http://taxman.openspending.org/gb"
      }
    }

Get tax rates for the current year:

    $ curl -s 'taxman.openspending.org/gb'
    {
      "data": {
        "allowances": {
          "personal": 8105,
          "personal_income_limit": 25400
        },
        "income_tax": {
          "bands": [
            {
              "width": 34370,
              "rate": 0.2
            },
    ...

Get the UK personal allowance for 2002:

    $ curl -s 'taxman.openspending.org/gb?year=2002' | json data.allowances.personal
    4615

Find out how much income tax you would pay with a salary of £22,000:

    $ curl -s 'taxman.openspending.org/gb?income=22000' | json calculation.income_tax.total
    2779

And so on. Specify a `callback` GET parameter if you want JSONP back rather than JSON.

How can I make it better?
-------------------------

You can add a tax calculator for your own jurisdiction! Fork this repository
and add a module for your jurisdiction, using the ISO 3166 two-letter code for
your country as a name. For example, if you wanted to add taxes for Spain,
you'd create `tax/es/index.coffee`, implementing the `calculate()` function:

    exports.calculate = (params) ->
      # do your tax calculation...

      return {
        options: [parsed options]
        data: [raw data used to perform the tax calculation]
        calculation: [the tax calculation]
      }

At the moment we place no restrictions on what you return from the calculate
function. That said, it is hoped that as we add more jurisdictions we will
work out which parts of the API we can standardise. **Consistency** across
jurisdictions is very important if TaxMan is to be useful, and at the moment
we are relying entirely on contributors' discipline to ensure it.
  
Developer details
-----------------

To run the server locally, you'll need to have [Node.js](http://nodejs.org)
and [npm](http://npmjs.org) installed. You can then run:

    npm install .
    `npm bin`/coffee serve.coffee
