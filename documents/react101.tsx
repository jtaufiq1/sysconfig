// Components: UI piece with appearance and logic
// Basically javascript functions that return markup
function MyButton() {
    return (
        <button>I'm a button</button>
    );
}


// React uses an optional JSX syntax [which is more stricter than HTML] for convenience
// React component cannot return multiple JSX tags
function AboutPage() {
    return (
     <div>
      <h1>About</h>
      <p>Hello there. <br /> How do you do?</p>
     <div/>
    );
}

// components can be nested into another component
// React components must start with a capital letter
export default function MyApp() {
    return (
        <div>
         <h1>Welcome to my app</h1>
         <MyButton />
        </div>
    );
}
