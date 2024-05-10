import React from 'react';
import '../css/NotFound.css'; // Make sure the path matches your project structure

function NotFound() {
    return (
        <div className="not-found-container">
            <h1>404</h1>
            <h2>Page Not Found</h2>
            <p>The page you are looking for might have been removed, had its name changed, or is temporarily unavailable.</p>
        </div>
    );
}

export default NotFound;
