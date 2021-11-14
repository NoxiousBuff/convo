import 'dart:core';

final userInterest = Interest();

class Interest {
  final science = [
    'Animals',
    'Astronomy',
    'Biology',
    'Chemistry',
    'Earth Science',
    'Electricity',
    'Inventions',
    'NASA',
    'Physics',
    'Plants',
    'Robotics',
    'Scientists & Inventors',
    'Space'
  ];

  final codingLanguages = [
    'Python',
    'JavaScript',
    'Java',
    'C#',
    'C++',
    'Dart',
    'C',
    'Swift',
    'PHP',
    'Kotlin',
    'Ruby',
    'Go'
  ];

  final populatInterests = [
    'Anime',
    'Cats',
    'Chilling',
    'Dogs',
    'Gen Z ',
    'LGBTQ+ Rights',
    'Minecraft',
    'Music',
    'Netflix',
    'Roblox',
    'Tiktok',
  ];

  final moviesAndTelevision = [
    'A24',
    'Adult Swim',
    'Adventure Time',
    'Horror Story',
    'Anime',
    'Attack On Titan',
    'Bleach',
    'Bong Hoon Jo',
    'Bungo Stray Dogs',
    'Camp Camp',
    'Cartoon Network',
    'Criterion Collection',
    'Crunchy Roll',
    'Death Note',
    'Disney+',
    'Documentries',
    'Dragon Ball z',
    'Escape the night',
    'Euphoria',
    'Girls From NoWhere',
    'Glee',
    'Grey\'s Anatomy',
    'Hamilton',
    'Harry Potter',
    'Impractical Jokers',
    'Love Island UK',
    'Madmen',
    'Marvel',
    'Miraculous',
    'Musical Theatre',
    'My Hero Academia',
    'My Little Pony',
    'Netflix',
    'Nicklodeon',
    'Spiderman - No Way Home',
    'One Piece',
    'Pokemon',
    'Real Housewife',
    'Regular Show',
    'Rick and Morty',
    'Robert Pattinson',
    'Sailor\'Moon',
    'ScreenWriting',
    'She-Ra',
    'South Park',
    'Sponge Bob',
    'Star Wars',
    'Steven Universe',
    'Stranger Things',
    'The Bachelor',
    'The Last Airbender',
    'The Walking Dead',
    'Vampire Diaries',
    'Wanda Vision',
  ];

  final gaming = [
    'Adorable Home',
    'Among Us',
    'Animal Crossing',
    'Apex Legends',
    'Assassin\'s Creed',
    'Call Of Duty',
    'Chess',
    'Cookie Run',
    'Dead By DayLight',
    'Dungeons and Dragons',
    'Dragon Scrolls',
    'FPS',
    'Fall Guys',
    'Fortnite',
    'Genshin Impact',
    'League of Legends',
    'Miitopia',
    'Minecraft',
    'Nintendo',
    'Omori',
    'Overwatch',
    'Persona 5',
    'Playstation',
    'Pokemon',
    'Poker',
    'Red Dead Redemption',
    'Resident Evil',
    'Roblox',
    'Rocket League',
    'Streaming',
    'Super Smash Bros',
    'Valorant',
    'Xbox',
    'Your Turn To Die',
  ];

  final bookAndLiterature = [
    'Book Recommendations',
    'Business Books',
    'Fan Fiction',
    'Finacial Literacy',
    'Graphic Novels',
    'Harry Potter',
    'Home Stuck',
    'Lord Of The Rings',
    'Manga',
    'Poetry',
    'Productivity',
    'Self-help Books',
    'True Crime',
    'Twilight',
  ];

  final sports = [
    'Baseball',
    'Basketball',
    'Cricket',
    'Fishing',
    'Football',
    'Golf',
    'Parkour',
    'Rugby',
    'Snowboarding',
    'Soccer',
    'Tennis',
  ];

  final activities = [
    'ASMR',
    'Astrology',
    'Astronomy',
    'Baking',
    'Camping',
    'Chilling',
    'Coffee',
    'Cooking',
    'DIY',
    'Dance',
    'Design',
    'Science Experiments',
    'Festivals',
    'Films',
    'Foodie',
    'Gardening',
    'History',
    'Instagram',
    'Interior Design',
    'Journaling',
    'Karaoke',
    'Laying Down',
    'Lego',
    'Mental Health',
    'Music Production',
    'Mythology',
    'New Friends',
    'Puzzles',
    'Reading',
    'Skateboarding',
    'Skiing',
    'Spirituality',
    'Swimming',
    'Writing',
  ];

  final travel = [
    'Africa',
    'Asia',
    'Canada',
    'New Life',
    'Trains',
    'Travel Vlogger',
    'World Tour'
  ];

  final personalFinance = [
    'Binance Coin',
    'Bitcoin',
    'Couponing',
    'Crypto',
    'Dogecoin',
    'Ehereum',
    'Investing',
    'Shiba Inu',
    'Stocks'
  ];

  final lifeStages = [
    'Boomer',
    'Gen Z',
    'Milennial',
  ];

  final healthAndFitness = [
    'Climbing',
    'Cycling',
    'Gymnastics',
    'Hiking',
    'Lifting',
    'Pilates',
    'Self-Care',
    'Track & Field',
    'Working Out',
    'Yoga',
  ];

  final education = [
    'Exams',
    'Graduate',
    'High School',
    'In College',
    'Learning English',
    'Learning French',
    'Learning Mandarin',
    'Learning Spaninsh',
    'Studying',
  ];

  final careers = [
    'Internship',
    'Job Hunt',
    'Mentorship',
  ];

  final business = [
    'Investing',
    'Marketing',
    'Networking',
    'StartUps',
  ];

  final automotive = [
    'BMW',
    'Camaro',
    'Cars',
    'Dodge',
    'Drifting',
    'Ferrari',
    'Ford',
    'Formula 1',
    'Honda',
    'Jeep',
    'Lexus',
    'Mazda',
    'Motorcycle',
    'NASCAR',
    'Subaru',
    'Tesla',
    'Top Gear',
    'Trucks',
    'volvo',
  ];

  final styleAndFashion = [
    'CottageCore',
    'DIY',
    'Depop',
    'Eco-Friendly-Fashion',
    'Hypebeast',
    'Sewing',
    'Sneakers',
    'Street Wear',
    'Thrifting',
  ];

  final pets = [
    'Amphibians',
    'Cats',
    'Dogs',
    'Monekys',
    'Reptile',
    'Rodents',
  ];

  final technologyAndComputing = [
    '3D Animation',
    'Apple',
    'Blender',
    'Elon Musk',
    'NFTs',
    'SpaceX',
  ];

  final socialIssues = [
    'Air Pollution',
    'Amazon Deforestation',
    'Cimate Change',
    'Famine',
    'Glacier Melting',
    'Global Waming',
    'LGBTQ+ Rights',
    'Mental Health',
    'Ocean Pollution',
    'Social Dilemma',
    'Team Trees',
    'Team Seas',
    'World Fires',
  ];

  final foodAndDrink = [
    'Dairy-free',
    'Eggitarian',
    'Fast Food',
    'Gluten Free',
    'Keto',
    'Non - vegetarian',
    'Paleo',
    'Vegan',
    'Vegitarian',
  ];

  final artsAndCulture = [
    '2D Art',
    '3D Art',
    'Animation',
    'Disney',
    'Drawing',
    'Graffiti',
    'Illustrations',
    'Memes',
    'Painting',
    'Performance Art',
    'Photography',
    'Podcasts',
    'Pottery',
    'Street Art',
    'Tattos',
    'Theatre',
    'Tiktok',
  ];
}
