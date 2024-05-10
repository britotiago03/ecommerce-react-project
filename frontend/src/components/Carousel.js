// Carousel.js
import React, { useState } from 'react';
import '../css/Carousel.css';

function Carousel({ banners }) {
    const [currentIndex, setCurrentIndex] = useState(0);

    const goToPrev = () => {
        const newIndex = currentIndex === 0 ? banners.length - 1 : currentIndex - 1;
        setCurrentIndex(newIndex);
    };

    const goToNext = () => {
        const newIndex = currentIndex === banners.length - 1 ? 0 : currentIndex + 1;
        setCurrentIndex(newIndex);
    };

    return (
        <div className="carousel">
            <button className="left-arrow" onClick={goToPrev}>&lt;</button>
            {banners.map((banner, index) => (
                <div
                    key={banner.id}
                    className={`banner ${index === currentIndex ? 'active' : ''}`}
                    style={{ opacity: index === currentIndex ? 1 : 0 }}>
                    <img src={banner.image} alt={banner.title} />
                </div>
            ))}
            <button className="right-arrow" onClick={goToNext}>&gt;</button>
        </div>
    );
}

export default Carousel;
