CREATE TABLE haikus (
    id              SERIAL PRIMARY KEY,
    haiku           text,
    image           text,
    hearts          int
);

INSERT INTO haikus (haiku, image, hearts) VALUES
    (
        E'Pulling on my leash,\nTo meet my newest best friend,\nEvery single dog',
        'car.jpg',
        0
    ),
    (
        E'Busy time at work,\nSo much to get done today,\nCircle back re: naps',
        'sun.jpg',
        0
    ),
    (
        E'The humans are home,\nThey don''t ever go outside,\nJune loves quarantine',
        'blanket.jpg',
        0
    ),
    (
        E'Sit, down, paw, leave, stay,\nIf I try them all at once,\nGuaranteed a treat',
        'sunlight.jpg',
        0        
    ),
    (
        E'It is a new day,\nWake up, yawn, and downward dog,\nHumans say BIG STRETCH',
        'pillow.jpg',
        0        
    )
;