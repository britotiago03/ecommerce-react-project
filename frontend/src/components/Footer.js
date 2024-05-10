// Footer.js
import React from 'react';
import { Link } from 'react-router-dom';
import '../css/Footer.css'

function Footer() {
    return (
        <footer>
            <p>© 2024 ElectroMart, Inc.</p>
            <Link to="">About Us</Link>
            <Link to="">Terms of Service</Link>
            <Link to="">Privacy Policy</Link>
        </footer>
    );
}

export default Footer;
