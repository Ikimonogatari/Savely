import { useNavigate } from "react-router-dom";

import Container from '@mui/material/Container';
import Stack from '@mui/material/Stack';
import Button from '@mui/material/Button';
import Typography from '@mui/material/Typography';


export default function Home(){
  let navigate = useNavigate();

  return (
    <Container maxWidth="md">
      <Stack
        justifyContent="center"
        spacing={2}
        sx={{ height: "100vh" }}
        alignItems="center"
        >
        <Typography variant="h2" gutterBottom>
            Ready to save the world ?
        </Typography>
        <Stack direction="row" spacing={2}>
          <Button onClick={() => { navigate("/client") }} size="large" color="primary" variant="outlined">
            <Typography variant="h6">YES</Typography>
          </Button>
        </Stack>
      </Stack>
    </Container>
  )
}
