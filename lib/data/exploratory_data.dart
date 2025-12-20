List<List<String>> iaData = [
  // Header Row
  ['question', 'a', 'b', 'c', 'd', 'descriptonA', 'descriptonB', 'descriptonC', 'descriptonD', 'answer'],

  // 1
  ['Which tool is used to set and measure an angle or check for squareness in woodworking?', 'Caliper', 'Try Square', 'Level', 'T-bevel', 'The caliper measures the diameter or thickness.', 'This is the correct answer; a Try Square checks for 90-degree angles.', 'The level ensures a surface is horizontal or vertical.', 'The T-bevel is used to transfer an angle, not necessarily check for squareness.', 'b'],
  // 2
  ['What is the primary function of a **circuit breaker** in a home electrical system?', 'To store electrical energy.', 'To automatically open a circuit when excessive current flows.', 'To regulate voltage supply.', 'To convert AC to DC current.', 'Batteries store energy, not circuit breakers.', 'This is the correct answer; the breaker protects the wiring from overheating and fire.', 'Voltage regulators manage power quality, not current overload protection.', 'Transformers or rectifiers convert current type.', 'b'],
  // 3
  ['In concrete mixing, what is the purpose of adding **sand**?', 'To increase the strength and act as the main binder.', 'To fill the voids between the coarse aggregates and make the mix workable.', 'To slow down the setting time of the mixture.', 'To improve the waterproofing capability.', 'Cement is the main binder, not sand.', 'This is the correct answer; sand (fine aggregate) is critical for workability and filling gaps.', 'Admixtures are used to slow or speed up setting time.', 'Special additives or denser mixing improves waterproofing.', 'b'],
  // 4
  ['Which type of joint is commonly used to join two pieces of wood end-to-end for longer lengths?', 'Mortise and Tenon Joint', 'Dovetail Joint', 'Butt Joint', 'Lap Joint', 'Mortise and tenon is for framing, connecting two pieces at right angles.', 'Dovetail is a strong corner joint for boxes or drawers.', 'This is the correct answer; the Butt Joint is the simplest end-to-end connection, though often reinforced.', 'A lap joint involves overlapping two pieces, often used for length but weaker than a simple butt joint.', 'c'],
  // 5
  ['When measuring wire gauge, which number indicates a **thicker** wire?', '14 AWG', '10 AWG', '18 AWG', '22 AWG', '14 AWG is a medium gauge.', 'This is the correct answer; in the American Wire Gauge (AWG) system, a lower number means a larger diameter (thicker wire).', '18 AWG is a thin gauge.', '22 AWG is a very thin gauge.', 'b'],
  // 6
  ['What is the term for a permanent change in the shape of metal caused by hammering or striking?', 'Tempering', 'Annealing', 'Malleability', 'Peening', 'Tempering reduces the hardness of the metal.', 'Annealing softens the metal for easier machining.', 'Malleability is the *property* of being shaped, not the process itself.', 'This is the correct answer; Peening is the process of cold working a metal surface using impact to relieve stress and change its shape.', 'd'],
  // 7
  ['In plumbing, what fixture is primarily used to prevent sewer gases from entering the building?', 'Shut-off Valve', 'Water Heater', 'P-trap', 'Pressure Regulator', 'The shut-off valve controls water flow.', 'The water heater raises water temperature.', 'This is the correct answer; the P-trap (or U-bend) holds a seal of water that blocks sewer gas entry.', 'The pressure regulator controls water pressure.', 'c'],
  // 8
  ['Which component of an internal combustion engine converts the linear motion of the piston into rotational motion?', 'Camshaft', 'Crankshaft', 'Cylinder Head', 'Spark Plug', 'The camshaft controls valve timing.', 'This is the correct answer; the crankshaft performs the essential conversion to power the vehicle.', 'The cylinder head seals the combustion chamber.', 'The spark plug ignites the air-fuel mixture.', 'b'],
  // 9
  ['What is the solvent most commonly used to thin oil-based paints and clean paint brushes?', 'Acetone', 'Denatured Alcohol', 'Lacquer Thinner', 'Mineral Spirits', 'Acetone is mainly used for plastics and strong adhesives.', 'Denatured alcohol is used for shellac and spirit-based dyes.', 'Lacquer thinner is too aggressive and only for lacquer-based finishes.', 'This is the correct answer; Mineral Spirits (or paint thinner) is the standard, mild solvent for oil-based paints.', 'd'],
  // 10
  ['A **ball-peen hammer** is primarily designed for use in which field?', 'Upholstery and fabric work.', 'Drywall installation.', 'Metalworking and driving punches/chisels.', 'Finish carpentry.', 'Upholstery uses tack hammers or electric staplers.', 'Drywall uses a specialized drywall hammer.', 'This is the correct answer; its rounded (peen) face is perfect for shaping metal, riveting, and setting metal components.', 'Finish carpentry uses a claw hammer or finishing hammer.', 'c'],
];

List<List<String>> heData = [
  // Header Row
  ['question', 'a', 'b', 'c', 'd', 'descriptonA', 'descriptonB', 'descriptonC', 'descriptonD', 'answer'],

  // 1
  ['In cooking, the process of gently folding a light mixture (like beaten egg whites) into a heavier mixture is called:', 'Whisking', 'Creaming', 'Sifting', 'Cutting and Folding', 'Whisking is vigorously beating ingredients to incorporate air.', 'Creaming is beating fat and sugar until light and fluffy.', 'Sifting is passing dry ingredients through a sieve.', 'This is the correct answer; this delicate motion incorporates air without deflating the light mixture.', 'd'],
  // 2
  ['What is the best way to safely thaw frozen meat?', 'On the kitchen counter at room temperature.', 'In the microwave and then immediately cook it.', 'In a bowl of hot water.', 'In the refrigerator or submerged in cold water.', 'Thawing at room temperature allows bacteria to multiply rapidly.', 'Microwaving can partially cook the meat, leading to uneven cooking and bacteria growth.', 'Hot water will heat the outer layer into the Danger Zone (40°F - 140°F).', 'This is the correct answer; these methods keep the meat below the temperature danger zone.', 'd'],
  // 3
  ['Which sewing machine part controls the length of the stitches?', 'Tension Regulator', 'Bobbin Winder', 'Feed Dog', 'Stitch Regulator', 'The tension regulator controls the tightness of the thread.', 'The bobbin winder transfers thread to the bobbin.', 'The feed dog moves the fabric beneath the needle.', 'This is the correct answer; the stitch regulator (or length control) determines the forward movement of the feed dog, thus controlling stitch length.', 'd'],
  // 4
  ['A **well-balanced meal** should primarily include food items from which three main categories (aside from water)?', 'Meat, Pasta, and Sugar', 'Go, Grow, and Glow Foods', 'Desserts, Appetizers, and Main Course', 'Fats, Oils, and Sweets', 'This is too narrow and includes excess sugar.', 'This is the correct answer; these terms cover Carbohydrates, Proteins, and Vitamins/Minerals.', 'These are course types, not nutritional categories.', 'This group should only be consumed sparingly.', 'b'],
  // 5
  ['When pressing a garment while sewing, the seam allowance should generally be pressed in which direction?', 'Towards the garment center.', 'Open (flat) on both sides.', 'Towards the seam with the heaviest fabric.', 'Towards the hemline.', 'This is not the standard rule and can lead to a bulky finish.', 'This is the correct answer; pressing the seam open reduces bulk and gives a flat, professional finish.', 'This is sometimes done, but pressing open is usually preferred.', 'This is only for hems, not seams.', 'b'],
  // 6
  ['What is the recommended cleaning solution for safely removing grease stains from a silk blouse?', 'Chlorine bleach.', 'Undiluted vinegar.', 'A small amount of liquid laundry detergent applied directly.', 'Hot water and bar soap.', 'Chlorine bleach will severely damage silk fibers.', 'Vinegar can set some stains and damage delicate fabric over time.', 'This is the correct answer; gentle detergent and lukewarm water are safe for protein fibers like silk.', 'Hot water will set the grease stain permanently.', 'c'],
  // 7
  ['In a typical household budget, which expense should be categorized under **"Fixed Expenses"**?', 'Groceries', 'Electric Bill', 'Mortgage Payment', 'Entertainment', 'Groceries are variable and change monthly.', 'The electric bill is a variable expense.', 'This is the correct answer; a mortgage or rent payment is a set, predictable amount each month.', 'Entertainment is highly discretionary and variable.', 'c'],
  // 8
  ['Which kitchen utensil is used to separate solid ingredients (like pasta or vegetables) from liquid?', 'Ladle', 'Whisk', 'Colander', 'Spatula', 'A ladle is used to serve liquid.', 'A whisk is used to beat ingredients.', 'This is the correct answer; a colander (or strainer) is designed with holes to drain liquid while retaining solids.', 'A spatula is used for flipping or spreading.', 'c'],
  // 9
  ['What is the primary food preservation method involved in making traditional **dried fish** (e.g., *daing*)?', 'Pickling', 'Fermentation', 'Dehydration (Drying)', 'Canning', 'Pickling uses vinegar or brine.', 'Fermentation uses beneficial bacteria/yeast.', 'This is the correct answer; removing moisture (dehydration) inhibits microbial growth and extends shelf life.', 'Canning involves sealing in sterile jars under heat.', 'c'],
  // 10
  ['When purchasing clothes, what fiber is known for being durable, quick-drying, and highly resistant to wrinkles?', 'Linen', 'Cotton', 'Polyester', 'Wool', 'Linen is durable but wrinkles easily.', 'Cotton is comfortable but wrinkles and takes time to dry.', 'This is the correct answer; Polyester is a synthetic fiber prized for its strength and wrinkle resistance.', 'Wool is warm and wrinkle-resistant but slow to dry.', 'c'],
];

List<List<String>> agriFisheryData = [
  // Header Row
  ['question', 'a', 'b', 'c', 'd', 'descriptonA', 'descriptonB', 'descriptonC', 'descriptonD', 'answer'],

  // 1
  ['What essential nutrient is represented by the letter **P** in the N-P-K fertilizer formula?', 'Nitrogen', 'Potassium', 'Phosphorus', 'Sulfur', 'N stands for Nitrogen, which promotes leafy growth.', 'K stands for Potassium, which promotes fruit/flower growth.', 'This is the correct answer; P stands for Phosphorus, which is vital for root development and flowering.', 'Sulfur is a secondary nutrient.', 'c'],
  // 2
  ['The process of preparing the soil for planting by breaking up and overturning it is called:', 'Weeding', 'Harrowing', 'Irrigation', 'Plowing', 'Weeding removes unwanted plants.', 'Harrowing smoothes and levels the soil after plowing.', 'Irrigation is supplying water to the land.', 'This is the correct answer; plowing (or tilling) is the initial deep soil preparation.', 'd'],
  // 3
  ['In aquaculture, what term refers to the raising of fish in cages or enclosures suspended in open water bodies like lakes or rivers?', 'Hatchery', 'Intensive Culture', 'Cage Culture', 'Mariculture', 'Hatchery is a facility for breeding and hatching fish.', 'Intensive culture is a high-density system, often indoors.', 'This is the correct answer; cage culture utilizes existing open water areas for fish growth.', 'Mariculture is the culture of marine organisms in saltwater.', 'c'],
  // 4
  ['Which farm tool is best used for applying liquid fertilizers or pesticides to crops?', 'Spade', 'Sprayer', 'Sickle', 'Wheelbarrow', 'The spade is for digging and lifting soil.', 'This is the correct answer; the sprayer is designed to evenly distribute liquid chemicals.', 'The sickle is used for cutting tall grasses or grain.', 'The wheelbarrow is for transporting materials.', 'b'],
  // 5
  ['What type of farm animal feeds on plant materials, such as grass, hay, and silage?', 'Omnivore', 'Carnivore', 'Herbivore', 'Insectivore', 'Omnivores eat both plants and meat.', 'Carnivores eat meat only.', 'This is the correct answer; herbivores are anatomically adapted to consume primarily plant matter.', 'Insectivores primarily eat insects.', 'c'],
  // 6
  ['What is the most crucial step in the post-harvest handling of fresh fruits and vegetables to prevent spoilage?', 'Waxing', 'Proper Storage Temperature (Refrigeration)', 'Canning', 'Deep Freezing', 'Waxing only adds a protective layer, not spoilage prevention.', 'This is the correct answer; maintaining optimal cold chain management slows respiration and microbial growth significantly.', 'Canning is a long-term preservation process, not post-harvest handling.', 'Deep freezing is too extreme for most fresh produce and damages texture.', 'b'],
  // 7
  ['In fish anatomy, what organ is responsible for extracting oxygen from the water?', 'Swim Bladder', 'Lateral Line', 'Gills', 'Scales', 'The swim bladder regulates buoyancy.', 'The lateral line detects water movement and vibration.', 'This is the correct answer; the gills are the respiratory organs in fish.', 'Scales provide protection.', 'c'],
  // 8
  ['Which is the common name for the practice of raising both crops and livestock in the same integrated system?', 'Monoculture', 'Agroforestry', 'Intercropping', 'Mixed Farming', 'Monoculture is growing a single crop repeatedly.', 'Agroforestry integrates trees/shrubs, not livestock.', 'Intercropping is growing two or more crops simultaneously.', 'This is the correct answer; Mixed Farming involves both raising crops and animals simultaneously on the same farm.', 'd'],
  // 9
  ['What is the minimum moisture level that should be maintained in a compost pile for effective decomposition?', 'Less than 10% (very dry)', '15% to 25% (slightly moist)', '40% to 60% (like a wrung-out sponge)', 'Over 80% (saturated)', 'Less than 10% is too dry for microbes to work.', 'This range is too dry for optimal microbial activity.', 'This is the correct answer; the pile must be consistently moist for aerobic microorganisms to thrive.', 'Over 80% is too wet and will cause anaerobic (smelly) decomposition.', 'c'],
  // 10
  ['In commercial chicken farming, which type of housing system is known for keeping birds confined to small wire enclosures, often stacked?', 'Free-Range System', 'Deep Litter System', 'Battery Cage System', 'Open-Sided House System', 'Free-range allows chickens outdoor access.', 'Deep litter uses the floor with absorbent material, common in small-scale farming.', 'This is the correct answer; the battery cage system confines birds in small wire cages, maximizing space in commercial operations.', 'Open-sided houses are large structures with open walls for natural ventilation.', 'c'],
];

List<List<String>> ictData = [
  // Header Row
  ['question', 'a', 'b', 'c', 'd', 'descriptonA', 'descriptonB', 'descriptonC', 'descriptonD', 'answer'],

  // 1
  ['What hardware component is considered the "brain" of the computer, responsible for executing instructions?', 'RAM', 'Hard Drive', 'Motherboard', 'CPU', 'RAM stores currently running data, not the execution unit.', 'The Hard Drive stores permanent data.', 'The Motherboard is the central connection hub.', 'This is the correct answer; the Central Processing Unit (CPU) executes all program instructions.', 'd'],
  // 2
  ['Which type of cable is typically used to connect a computer to a local area network (LAN) and has an RJ-45 connector?', 'HDMI Cable', 'USB Cable', 'Ethernet Cable', 'VGA Cable', 'HDMI carries high-definition video and audio.', 'USB is for peripherals and power.', 'This is the correct answer; Ethernet (often Cat5e or Cat6) is the standard for wired network connection.', 'VGA carries analog video signals.', 'c'],
  // 3
  ['What does **RAM** stand for?', 'Random Application Module', 'Read Access Memory', 'Rapid Access Manager', 'Random Access Memory', 'This is incorrect; it is not a standard computer term.', 'This describes a ROM chip, not RAM.', 'This is incorrect; it is not a standard computer term.', 'This is the correct answer; RAM is temporary, volatile memory used by the OS and running programs.', 'd'],
  // 4
  ['The most secure way to dispose of sensitive data on a hard disk drive before discarding it is through:', 'Formatting the drive quickly.', 'Deleting the files via the Recycle Bin.', 'Physical destruction or degaussing (magnetic erasure).', 'Renaming the files.', 'Quick formatting only removes the file index, not the data.', 'Deleting sends files to the recycle bin and is recoverable.', 'This is the correct answer; this physically ensures data cannot be recovered by any means.', 'Renaming does nothing to the data content.', 'c'],
  // 5
  ['In programming, what is a **loop** primarily used for?', 'Making decisions between two paths (true or false).', 'Executing a block of code repeatedly.', 'Storing multiple pieces of data under one name.', 'Defining a reusable block of code.', 'An "if-else" statement is used for decision-making.', 'This is the correct answer; a loop (like `for` or `while`) automates repetitive tasks.', 'An array or list is used for storing multiple data items.', 'A function or method is used for defining reusable code.', 'b'],
  // 6
  ['What is the protocol that ensures secured communication over a computer network, widely used for secure browsing on the Internet?', 'HTTP', 'FTP', 'HTTPS', 'TCP/IP', 'HTTP is the basic, unsecure transfer protocol.', 'FTP is for transferring files, often unsecurely.', 'This is the correct answer; HTTPS (Hypertext Transfer Protocol Secure) encrypts communication using SSL/TLS.', 'TCP/IP is the fundamental suite of network protocols.', 'c'],
  // 7
  ['What common type of malware disguises itself as a legitimate program or file to trick users into running it?', 'Worm', 'Adware', 'Trojan Horse', 'Spyware', 'A Worm is self-replicating and spreads autonomously.', 'Adware generates unwanted advertisements.', 'This is the correct answer; a Trojan Horse relies on deception to gain access to a system.', 'Spyware secretly monitors user activity.', 'c'],
  // 8
  ['Which operating system utility is used to logically organize and store files in contiguous sectors to improve performance?', 'Device Manager', 'Disk Cleanup', 'Disk Defragmenter', 'Task Manager', 'Device Manager manages hardware drivers.', 'Disk Cleanup removes unnecessary files.', 'This is the correct answer; Disk Defragmenter rearranges fragmented data for faster access.', 'Task Manager monitors running processes.', 'c'],
  // 9
  ['What is the best way to prevent Electrostatic Discharge (ESD) damage when working inside a computer case?', 'Wear rubber-soled shoes.', 'Keep the computer plugged in to ground it.', 'Use an Anti-Static Wrist Strap.', 'Work on a carpeted floor.', 'Rubber-soled shoes do not guarantee grounding.', 'The computer must be unplugged for safety.', 'This is the correct answer; the strap safely equalizes the charge between your body and the PC.', 'A carpeted floor generates high static electricity, making this the worst option.', 'c'],
  // 10
  ['What does the term **"phishing"** refer to in terms of online security?', 'Attacks that block user access to their data.', 'Creating fake websites to steal user credentials.', 'A type of computer virus that spreads through flash drives.', 'Using a powerful computer to guess passwords.', 'This describes a Denial of Service or Ransomware attack.', 'This is the correct answer; Phishing uses deceptive emails or websites to trick users into giving up sensitive information.', 'This describes a type of malware or worm.', 'This describes a Brute Force attack.', 'b'],
];

List<List<String>> entrepData = [
  // Header Row
  ['question', 'a', 'b', 'c', 'd', 'descriptonA', 'descriptonB', 'descriptonC', 'descriptonD', 'answer'],

  // 1
  ['Which Personal Entrepreneurial Competency (PEC) describes the willingness to stick with a course of action despite difficulties and obstacles?', 'Goal Setting', 'Risk-Taking', 'Persistence', 'Information Seeking', 'Goal Setting is defining clear objectives.', 'Risk-Taking is evaluating and taking calculated chances.', 'This is the correct answer; persistence is the ability to endure and continue striving toward a goal.', 'Information Seeking is gathering market data.', 'c'],
  // 2
  ['The document that outlines the nature of the business, sales and marketing strategy, and financial background is called the:', 'Feasibility Study', 'SWOT Analysis', 'Business Plan', 'Mission Statement', 'A Feasibility Study assesses the viability of the idea, done before the plan.', 'SWOT Analysis identifies internal Strengths/Weaknesses and external Opportunities/Threats.', 'This is the correct answer; the Business Plan is the detailed roadmap for the entire venture.', 'The Mission Statement is a brief declaration of purpose.', 'c'],
  // 3
  ['In the **4 Ps of Marketing**, which "P" is concerned with distribution channels, location, and logistics?', 'Product', 'Price', 'Place', 'Promotion', 'Product refers to the item or service itself.', 'Price is the monetary value of the product.', 'This is the correct answer; Place covers how the product gets from the business to the customer.', 'Promotion involves communication like advertising and public relations.', 'c'],
  // 4
  ['What is the term for the group of consumers a business aims to sell its products or services to?', 'Competitors', 'Investors', 'Target Market', 'Suppliers', 'Competitors offer similar products.', 'Investors provide capital.', 'This is the correct answer; the Target Market is the specific segment of consumers the business focuses on.', 'Suppliers provide raw materials or goods.', 'c'],
  // 5
  ['The financial statement that shows a business\'s assets, liabilities, and owner\'s equity at a specific point in time is the:', 'Income Statement', 'Cash Flow Statement', 'Balance Sheet', 'Trial Balance', 'The Income Statement shows revenue and expenses over a period.', 'The Cash Flow Statement tracks movement of cash over a period.', 'This is the correct answer; the Balance Sheet provides a snapshot of the business\'s financial position.', 'The Trial Balance is a bookkeeping worksheet.', 'c'],
  // 6
  ['When an entrepreneur sets a high initial price for a new, unique product before gradually lowering it, this pricing strategy is called:', 'Penetration Pricing', 'Cost-Plus Pricing', 'Price Skimming', 'Psychological Pricing', 'Penetration Pricing sets a low price to quickly gain market share.', 'Cost-Plus is marking up the production cost.', 'This is the correct answer; Price Skimming "skims" maximum profit from early adopters before competition arrives.', 'Psychological Pricing uses prices ending in .99 or .95.', 'c'],
  // 7
  ['Which element is considered an **external threat** in a SWOT analysis?', 'Poor financial management', 'Lack of a strong brand', 'New government regulation that increases operating costs', 'Highly skilled team members', 'Poor financial management is an internal weakness.', 'Lack of a strong brand is an internal weakness.', 'This is the correct answer; New regulation is an external factor that poses a potential negative impact.', 'Highly skilled team members are an internal strength.', 'c'],
  // 8
  ['Which term describes the total revenue earned when the total revenue equals the total expenses, meaning there is zero profit?', 'Net Profit', 'Operating Loss', 'Break-Even Point', 'Gross Margin', 'Net Profit is the amount remaining after all costs are paid.', 'Operating Loss occurs when expenses exceed revenue.', 'This is the correct answer; the Break-Even Point is the point where the business neither makes nor loses money.', 'Gross Margin is revenue minus the cost of goods sold.', 'c'],
  // 9
  ['What is the primary motive that drives an entrepreneur to start and sustain a business, according to economic theory?', 'Social Responsibility', 'Compliance with Law', 'Profit Maximization', 'Employee Satisfaction', 'Social Responsibility is an objective, but not the primary driver.', 'Compliance is mandatory, not a driving motive.', 'This is the correct answer; while other factors exist, the fundamental driver for starting a business is financial gain.', 'Employee Satisfaction helps, but is a means to achieve the primary goal.', 'c'],
  // 10
  ['An entrepreneur who frequently seeks to update their product features and packaging based on current consumer feedback exhibits which PEC?', 'Decisiveness', 'Commitment to Work Contract', 'Responding to Feedback/Opportunity Seeking', 'Calculated Risk-Taking', 'Decisiveness is making timely decisions.', 'Commitment to Work Contract is about meeting deadlines.', 'This is the correct answer; actively using consumer feedback is a form of responding to market data and opportunity seeking.', 'Calculated Risk-Taking involves financial/operational risks.', 'c'],
];

List<List<String>> ttlData = [
  // Header Row
  ['question', 'a', 'b', 'c', 'd', 'descriptonA', 'descriptonB', 'descriptonC', 'descriptonD', 'answer'],

  // 1
  ['What drawing tool is used primarily to draw **horizontal** lines and serve as a guide for drawing triangles?', 'Compass', 'Protractor', 'T-square', 'French Curve', 'The compass is for drawing circles and arcs.', 'The protractor is for measuring and drawing angles.', 'This is the correct answer; the T-square\'s head slides along the edge of the board to ensure horizontal lines.', 'The French curve is for irregular, non-circular curves.', 'c'],
  // 2
  ['In orthographic projection, which view typically contains the height and width of the object?', 'Front View', 'Right Side View', 'Top View', 'Isometric View', 'The Front View contains the height and width (length).', 'The Right Side View contains the height and depth.', 'The Top View contains the width and depth.', 'The Isometric view is a 3D pictorial view.', 'a'],
  // 3
  ['Which line convention is used to represent edges of the object that are **hidden** from the viewer\'s sight?', 'Visible Line (Object Line)', 'Center Line', 'Phantom Line', 'Hidden Line', 'The visible line shows the outlines of the object you can see.', 'The center line shows the center of holes or symmetry.', 'The phantom line shows alternate positions of a moving part.', 'This is the correct answer; the hidden line is a series of short dashes.', 'd'],
  // 4
  ['What instrument is best used for dividing a line or distance into equal parts?', 'Triangle', 'Dividers', 'Scale Rule', 'Adjustable Curve', 'A triangle is used to draw vertical and inclined lines.', 'This is the correct answer; dividers are used for transferring measurements and dividing lines precisely.', 'A scale rule is used to measure distances according to a ratio.', 'An adjustable curve is used for drawing irregular curves.', 'b'],
  // 5
  ['A standard architectural drawing scale written as **1:100** means:', '1 cm on the drawing equals 100 mm on the object.', '1 unit on the drawing equals 100 units on the object.', 'The drawing is 100 times larger than the object.', 'The drawing is 1/10 the size of the object.', '1 cm equals 1 meter (1000 mm), which is a common 1:100 ratio, but the basic definition is universal units.', 'This is the correct answer; it is a direct ratio of drawing measurement to actual object measurement.', 'This is incorrect; the drawing is smaller (reduced).', 'This would be a 1:10 ratio.', 'b'],
  // 6
  ['When performing lettering on a technical drawing, the primary concern is always:', 'Ornamentation (decoration)', 'Uniformity and Legibility', 'Using a fancy script font', 'Changing font sizes constantly', 'Lettering should be simple and functional, not ornamental.', 'This is the correct answer; all letters should be consistently sized, spaced, and easy to read.', 'Script fonts are never used in technical drafting.', 'Inconsistent sizing violates uniformity.', 'b'],
  // 7
  ['What is the term for the numerical value written on a drawing that specifies the size or location of a feature?', 'Notation', 'Tolerance', 'Dimension', 'Projection', 'Notation is a general term for notes.', 'Tolerance is the allowable variation in a size.', 'This is the correct answer; a dimension is the measurement itself, typically placed using extension and dimension lines.', 'Projection is the method used to create the view.', 'c'],
  // 8
  ['In Computer-Aided Drafting (CAD), what command is used to trim objects to meet the edge of another object?', 'Extend', 'Fillet', 'Mirror', 'Trim', 'Extend lengthens an object to meet another object.', 'Fillet rounds the corner where two lines meet.', 'Mirror creates a symmetrical copy of an object.', 'This is the correct answer; the Trim command is used to cut off parts of a line or object that extend past an intersection.', 'd'],
  // 9
  ['What type of line is used to indicate the line on which a dimension is placed?', 'Cutting Plane Line', 'Extension Line', 'Dimension Line', 'Break Line', 'The cutting plane line indicates where a sectional view is taken.', 'The extension line extends from the object to define the boundary of the dimension.', 'This is the correct answer; the Dimension Line is the line with arrowheads that shows the extent of the measurement.', 'The break line is used to show that an object is cut short.', 'c'],
  // 10
  ['In a **Third-Angle Projection** drawing setup, where is the Top View placed relative to the Front View?', 'To the left of the Front View.', 'Directly below the Front View.', 'Directly above the Front View.', 'To the right of the Front View.', 'This is where the Left Side View is typically placed.', 'This is the convention for **First-Angle Projection**.', 'This is the correct answer; in Third-Angle Projection (common in the US and Philippines), the Top View is placed directly above the Front View.', 'This is where the Right Side View is typically placed.', 'c'],
];