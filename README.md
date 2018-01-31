
# Liberate your Blockfolio data

The Blockfolio app is a great app, but unfortunately it keeps your precious data hostage. It won't offer (so far) a way to export any of the entered trades, which you could need for multiple reasons, like easier/better bookkeeping or creating tax reports. Or perhaps you just want to migrate to a competing app without having to re-enter every trade from scratch, manually. So I took a stab at leveraging the REST API used by Blockfolio to fetch _our own_ data in order to be able to export it into whatever other format you may need or want. Currently this app only writes the trades to the console for each coin in the portfolio, but it could be easily extended to write to e.g. a CSV file, or to use some existing XML scheme that describes the trades. It's up to you to adapt it to suit your needs.

This is a macOS app written in Objective-C, and so it requires Xcode to compile and run it. I probably should have written it in something more portable, like python, but alas I don't do python (yet), and ObjC was the easiest pick for me.
